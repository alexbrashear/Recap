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

typealias SendImageResult = Result<Void, PhotoError>
typealias SendImageCompletion = (SendImageResult) -> Void

struct PhotoNotifications {
    static let successfulSend = Notification.Name("successfulSend")
}

class PhotoManager {
    let imageUploader: ImageUploader
    let userController: UserController
    
    init(imageUploader: ImageUploader, userController: UserController) {
        self.imageUploader = imageUploader
        self.userController = userController
    }
    
    func sendImage(image: UIImage, to recipients: [Friend], completion: @escaping SendImageCompletion) {
        let key = ProcessInfo.processInfo.globallyUniqueString + ".jpeg"
        guard let localImageFile = imageUploader.save(image: image, with: key) else { return completion(.error(.unableToSaveImageLocally)) }
        
        // Store image in s3
        imageUploader.uploadImageToS3(fromLocalImageFile: localImageFile, withS3ImageKey: key) { s3ImageURL in
            guard let s3ImageURL = s3ImageURL else { return completion(.error(.uploadToS3Failure)) }
            // use film slot in backend
//            let photo = Photo(imageURL: s3ImageURL)
            completion(.success())
            NotificationCenter.default.post(name: PhotoNotifications.successfulSend, object: nil)
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
