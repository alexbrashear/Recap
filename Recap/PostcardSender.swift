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

class PostcardSender {
    let networkClient = NetworkClient()
    let imageUploader = ImageUploader()
    let temporaryDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory())
    
    func send(image: UIImage, to address: Address, completion: @escaping PhotoSendCompletion) {
        let key = ProcessInfo.processInfo.globallyUniqueString + ".jpeg"
        let localImageFile = temporaryDirectoryURL.appendingPathComponent(key)
        /// save image to temp directory
        let success = imageUploader.save(image: image, toUrl: localImageFile)
        if !success { return completion(nil, .unableToSaveImageLocally) }
        /// upload image to s3
        let postcardProvider = PostcardProvider()
        imageUploader.uploadImageToS3(fromLocalImageFile: localImageFile, withS3ImageKey: key) { s3ImageURL in
            guard let s3ImageURL = s3ImageURL else {
                return completion(nil, .uploadToS3Failure)
            }
            postcardProvider.send(image: s3ImageURL, to: address) { photo, error in
                completion(photo, error)
            }
        }
    }
}

class ImageUploader {
    
    private let bucket = "brashear-tompkins-lob-images"
    
    func save(image: UIImage, toUrl url: URL) -> Bool {
        let data = UIImageJPEGRepresentation(image, 1.0)
        return FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
    }
    
    func uploadImageToS3(fromLocalImageFile localImageFile: URL, withS3ImageKey key: String, completion: @escaping (URL?) -> Void) {
        AWSS3TransferUtility.default().uploadFile(localImageFile, bucket: bucket, key: key, contentType: "image/jpeg", expression: nil) { [weak self] task, error in
            completion(self?.createS3URL(withKey: key))
        }.continueWith { (task) -> Any? in
            if let error = task.error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
            return nil
        }
    }
    
    private func createS3URL(withKey key: String) -> URL? {
        return URL(string: "https://s3.amazonaws.com/\(bucket)/\(key)")
    }
}
