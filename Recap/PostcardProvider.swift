//
//  PostcardProvider.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/15/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

typealias PhotoSendCompletion = (_ photo: Photo?, _ error: PhotoError?) -> Void

class PostcardProvider {
    private let createPostcardURLString = "https://api.lob.com/v1/postcards"
    private let networkClient = NetworkClient()
    
    func send(image imageURL: URL, to address: Address, completion: @escaping (Date?, PhotoError?) -> Void) {
        guard let url = URL(string: createPostcardURLString) else { return }
        let data = metadata(forAddress: address, imageUrlString: imageURL.absoluteString)
        networkClient.POST(url: url, data: data) { json in
            guard let json = json  else { return completion(nil, .unknownFailure) }
            let expectedDeliveryString = json["expected_delivery_date"] as? String
            let expectedDeliveryDate = expectedDeliveryString?.dateFromStandard
            completion(expectedDeliveryDate, nil)
        }
    }
    
    func persist(postcard: Postcard) {
        let connection = DatabaseController.sharedInstance.newWritingConnection()
        connection.readWrite { transaction in
            var postcards = transaction.object(forKey: "postcards", inCollection: "postcards") as? [Postcard] ?? []
            if postcards.isEmpty {
                transaction.setObject([postcard], forKey: "postcards", inCollection: "postcards")
            } else {
                postcards.append(postcard)
                transaction.replace(postcards, forKey: "postcards", inCollection: "postcards")
            }
        }
    }
    
    private func metadata(forAddress address: Address, imageUrlString: String) -> Data? {
        let front = "<html><head><meta charset=\"UTF-8\"><link href=\"https://fonts.googleapis.com/css?family=Open+Sans\" rel=\"stylesheet\" type=\"text/css\"><title>Lob.com Sample 4x6 Postcard Front</title><style>*, *:before, *:after {-webkit-box-sizing: border-box;-moz-box-sizing: border-box;    box-sizing: border-box;  }  body {    width: 6.25in;    height: 4.25in;    margin: 0;    padding: 0;    /* If using an image, the background image should have dimensions of 1875x1275 pixels. */    background-image: url(\"\(imageUrlString)\");    background-size: cover;    background-repeat: no-repeat; background-position: center;  }  #safe-area {    position: center;    width: 5.875in;    height: 3.875in;    left: 0.1875in;    top: 0.1875in;    background-color: rgba(255,255,255,0.5);  }  .text {    margin: 10px;    font-family: \"Open Sans\";    font-weight: 400    font-size: 40px;    color: white;    text-shadow: 2px 2px black;  }</style></head><body>  </body></html>"
        let message = "this is a test from Alex and Dave"
        return "\(address.bodyString(withParent: "to"))&message=\(message)&front=\(front)".data(using: .utf8)
    }
}
