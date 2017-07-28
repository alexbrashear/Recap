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
    
    func send(image imageURL: URL, to address: Address, completion: @escaping (Photo?, PhotoError?) -> Void) {
        guard let url = URL(string: createPostcardURLString) else { return }
        let data = metadata(forAddress: address, imageUrlString: imageURL.absoluteString)
        networkClient.POST(url: url, data: data) { json in
            guard let json = json  else { return completion(nil, .unknownFailure) }
            let expectedDeliveryString = json["expected_delivery_date"] as? String
            guard let expectedDeliveryDate = expectedDeliveryString,
                let thumbnails = self.parseThumbnails(fromJson: json) else { return completion(nil, .parsingFailure) }
            let photo = Photo(imageURL: imageURL, expectedDeliveryDate: expectedDeliveryDate, thumbnails: thumbnails)
            completion(photo, nil)
        }
    }
    
    private func metadata(forAddress address: Address, imageUrlString: String) -> Data? {
        let front = "<html><head><meta charset=\"UTF-8\"><link href=\"https://fonts.googleapis.com/css?family=Open+Sans\" rel=\"stylesheet\" type=\"text/css\"><title>Lob.com Sample 4x6 Postcard Front</title><style>*, *:before, *:after {-webkit-box-sizing: border-box;-moz-box-sizing: border-box;    box-sizing: border-box;  }  body {    width: 6.25in;    height: 4.25in;    margin: 0;    padding: 0;    /* If using an image, the background image should have dimensions of 1875x1275 pixels. */    background-image: url(\"\(imageUrlString)\");    background-size: cover;    background-repeat: no-repeat; background-position: center;  }  #safe-area {    position: center;    width: 5.875in;    height: 3.875in;    left: 0.1875in;    top: 0.1875in;    background-color: rgba(255,255,255,0.5);  }  .text {    margin: 10px;    font-family: \"Open Sans\";    font-weight: 400    font-size: 40px;    color: white;    text-shadow: 2px 2px black;  }</style></head><body>  </body></html>"
        let back = "https://s3.amazonaws.com/recap-static-images/recap_watermark_v2.png"
        return "\(address.bodyString(withParent: "to"))&back=\(back)&front=\(front)".data(using: .utf8)
    }
    
    private func parseThumbnails(fromJson json: [String: AnyObject]) -> Thumbnails? {
        guard let thumbnailArray = json["thumbnails"] as? [[String: AnyObject]] else { return nil }
        if thumbnailArray.count != 2 { return nil }
        guard let front = parseThumbnailObject(thumbnail: thumbnailArray[0]),
            let back = parseThumbnailObject(thumbnail: thumbnailArray[1]) else { return nil }
        return front
    }
    
    private func parseThumbnailObject(thumbnail: [String: AnyObject]) -> Thumbnails? {
        guard let smallString = thumbnail["small"] as? String,
            let mediumString = thumbnail["medium"] as? String,
            let largeString = thumbnail["large"] as? String else { return nil }
        guard let small = URL(string: smallString),
            let medium = URL(string: mediumString),
            let large = URL(string: largeString) else { return nil }
        return Thumbnails(small: small, medium: medium, large: large)
    }
}
