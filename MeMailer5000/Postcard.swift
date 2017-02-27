//
//  Postcard.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/20/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class Thumbnails: NSObject, NSCoding {
    enum Keys: String {
        case small = "small"
        case medium = "medium"
        case large = "large"
    }
    
    var small: URL
    var medium: URL
    var large: URL
    
    init(small: URL, medium: URL, large: URL) {
        self.small = small
        self.medium = medium
        self.large = large
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let small = aDecoder.decodeObject(forKey: Keys.small.rawValue) as? URL,
              let medium = aDecoder.decodeObject(forKey: Keys.medium.rawValue) as? URL,
              let large = aDecoder.decodeObject(forKey: Keys.large.rawValue) as? URL
            else {
            assertionFailure("Unable to decode Thumbnail")
            return nil
        }
        self.init(small: small, medium: medium, large: large)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(small, forKey: Keys.small.rawValue)
        aCoder.encode(medium, forKey: Keys.medium.rawValue)
        aCoder.encode(large, forKey: Keys.large.rawValue)
    }
}

class Postcard: NSObject {
    enum Keys: String {
        case id = "id"
        case expectedDeliveryDate = "expected_delivery_date"
        case imageThumbnails = "imageThumbnails"
        case messageThumbnails = "messageThumbnails"
        case to = "to"
    }
    
    var id: String
    var expectedDeliveryDate: String
    var imageThumbnails: Thumbnails
    var messageThumbnails: Thumbnails
    var to: Address
    
    init(id: String, expectedDeliveryDate: String, imageThumbnails: Thumbnails, messageThumbnails: Thumbnails, to: Address) {
        self.id = id
        self.expectedDeliveryDate = expectedDeliveryDate
        self.imageThumbnails = imageThumbnails
        self.messageThumbnails = messageThumbnails
        self.to = to
    }
}
