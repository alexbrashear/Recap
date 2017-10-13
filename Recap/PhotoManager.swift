//
//  PostcardSender.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/12/17.
//  Copyright © 2017 memailer. All rights reserved.
//
import Foundation
import UIKit
import AWSS3

/// 1. Fetch friends addresses (1 request)
/// 2. Upload photo to s3 (1 -heavy- request)
/// 3. Create Photo in scaphold (1 request)
/// 4. Use Photo slots in scaphold (1 request ASYNC)
/// 5a. Create Photo-Address connection each recipient (n requests)
/// 5b. send photo through lob to each recipient (n requests)

typealias SendImageResult = Result<Void, PhotoError>
typealias SendImageCompletion = (SendImageResult) -> Void

struct PhotoNotifications {
    static let successfulSend = Notification.Name("successfulSend")
}

class PhotoManager {
    let imageUploader: ImageUploader
    let userController: UserController
    let photoSender: PhotoSender
    
    init(imageUploader: ImageUploader, userController: UserController, photoSender: PhotoSender) {
        self.imageUploader = imageUploader
        self.userController = userController
        self.photoSender = photoSender
    }
    
    func sendImage(image: UIImage, to recipients: [Friend], completion: @escaping SendImageCompletion) {
        let IDs = recipients.filter { $0.isFacebook }.map { return $0.facebookId! }
        var other = recipients.filter { !$0.isFacebook }.map { return $0.address! }
        userController.fetchFacebookAddresses(IDs: IDs) { [weak self] result in
            switch result {
            case .error:
                completion(.error(.unknownFailure))
            case let .success(addresses):
                other.append(contentsOf: addresses)
                self?.uploadImage(image: image, recipients: other, completion: completion)
            }
        }
    }
    
    func uploadImage(image: UIImage, recipients: [Address], completion: @escaping SendImageCompletion) {
        let key = ProcessInfo.processInfo.globallyUniqueString + ".jpeg"
        guard let localImageFile = imageUploader.save(image: image, with: key) else { return completion(.error(.unableToSaveImageLocally)) }
        
        // Store image in s3
        imageUploader.uploadImageToS3(fromLocalImageFile: localImageFile, withS3ImageKey: key) { [weak self] s3ImageURL in
            guard let s3ImageURL = s3ImageURL else { return completion(.error(.uploadToS3Failure)) }
            let photo = Photo(imageURL: s3ImageURL, recipients: recipients)
            self?.createPhoto(photo: photo, completion: completion)
        }
    }
    
    func createPhoto(photo: Photo, completion: @escaping SendImageCompletion) {
        userController.createPhoto(photo: photo) { [weak self] result in
            switch result {
            case .error:
                completion(.error(.unknownFailure))
            case let .success(photoId):
                var mutablePhoto = photo
                mutablePhoto.id = photoId
                self?.userController.usePhotos(numPhotos: photo.recipients.count, callback: {_ in})
                self?.sendPhoto(mutablePhoto, completion: completion)
            }
        }
    }
    
    func sendPhoto(_ photo: Photo, completion: @escaping SendImageCompletion) {
        photoSender.sendPhoto(photo) { result in
            switch result {
            case .error:
                completion(.error(.unknownFailure))
            case .success:
                completion(.success())
                NotificationCenter.default.post(name: PhotoNotifications.successfulSend, object: nil)
            }
        }
    }
}

class ImageUploader {
    
    private let bucket = "brashear-tompkins-lob-images"
    private let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
    
    func save(image: UIImage, with key: String) -> URL? {
        let localImageFile = temporaryDirectoryURL.appendingPathComponent(key)
        let data = UIImageJPEGRepresentation(image, 1.0)
        if FileManager.default.createFile(atPath: localImageFile.path, contents: data, attributes: nil) {
            return localImageFile
        } else {
            return nil
        }
    }
    
    func uploadImageToS3(fromLocalImageFile localImageFile: URL, withS3ImageKey key: String, completion: @escaping (URL?) -> Void) {
        AWSS3TransferUtility.default().uploadFile(localImageFile, bucket: bucket, key: key, contentType: "image/jpeg", expression: nil) { [weak self] task, error in
            DispatchQueue.main.async {
                completion(self?.createS3URL(withKey: key))
            }
        }.continueWith { (task) -> Any? in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            return nil
        }
    }
    
    private func createS3URL(withKey key: String) -> URL? {
        return URL(string: "https://s3.amazonaws.com/\(bucket)/\(key)")
    }
}
