//
//  PostcardProvider.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/15/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

typealias PhotoSendCompletion = (Result<Void, PhotoError>) -> Void

class Operation {
    var photoId: String
    var url: URL
    var address: Address
    var complete: Bool
    
    init(photoId: String, url: URL, address: Address) {
        self.photoId = photoId
        self.url = url
        self.address = address
        self.complete = false
    }
}

class PhotoSender {
    private let createPostcardURLString = "https://api.lob.com/v1/postcards"
    private let networkClient = NetworkClient()
    private let userController: UserController
    var operations = [Operation]()
    var completion: SendImageCompletion?
    
    init(userController: UserController) {
        self.userController = userController
    }
    
    func sendPhoto(_ photo: Photo, completion: @escaping SendImageCompletion) {
        guard let id = photo.id else { fatalError() }
        operations = [Operation]()
        self.completion = completion
        for address in photo.recipients {
            let operation = Operation(photoId: id, url: photo.imageURL, address: address)
            operations.append(operation)
            start(operation)
        }
    }
    
    private func start(_ op: Operation) {
        /// 1. Upload photo map collection
        /// 2. Send image to lob
        userController.createPhotoConnection(photoId: op.photoId, addressId: op.address.id) { [weak self, weak op] result in
            switch result {
            case .error:
                op?.complete = true
                self?.runCompletion()
            case .success:
                guard let op = op else { fatalError() }
                self?.send(image: op.url, to: op.address) { [weak op] result in
                    switch result {
                    case .error:
                        break
                    case .success:
                        break
                    }
                    op?.complete = true
                    self?.runCompletion()
                }
            }
        }
    }

    func send(image imageURL: URL, to address: Address, completion: @escaping PhotoSendCompletion) {
        guard let url = URL(string: createPostcardURLString) else { return }
        let data = metadata(forAddress: address, imageUrlString: imageURL.absoluteString)
        networkClient.POST(url: url, data: data) { json in
            guard let json = json  else { return completion(.error(.unknownFailure)) }
            let expectedDeliveryString = json["expected_delivery_date"] as? String
            guard let expectedDeliveryDate = expectedDeliveryString else { return completion(.error(.unknownFailure)) }
            completion(.success())
        }
    }

    private func metadata(forAddress address: Address, imageUrlString: String) -> Data? {
        let front = "<html><head><meta charset=\"UTF-8\"><link href=\"https://fonts.googleapis.com/css?family=Open+Sans\" rel=\"stylesheet\" type=\"text/css\"><title>Lob.com Sample 4x6 Postcard Front</title><style>*, *:before, *:after {-webkit-box-sizing: border-box;-moz-box-sizing: border-box;    box-sizing: border-box;  }  body {    width: 6.25in;    height: 4.25in;    margin: 0;    padding: 0;    /* If using an image, the background image should have dimensions of 1875x1275 pixels. */    background-image: url(\"\(imageUrlString)\");    background-size: cover;    background-repeat: no-repeat; background-position: center;  }  #safe-area {    position: center;    width: 5.875in;    height: 3.875in;    left: 0.1875in;    top: 0.1875in;    background-color: rgba(255,255,255,0.5);  }  .text {    margin: 10px;    font-family: \"Open Sans\";    font-weight: 400    font-size: 40px;    color: white;    text-shadow: 2px 2px black;  }</style></head><body>  </body></html>"
        let back = "https://s3.amazonaws.com/recap-static-images/recap_watermark_v2.png"
        return "\(address.bodyString(withParent: "to"))&back=\(back)&front=\(front)".data(using: .utf8)
    }
    
    private func runCompletion() {
        synced(self) {
            for operation in operations {
                if !operation.complete { return }
            }
            completion?(.success())
        }
    }
}
