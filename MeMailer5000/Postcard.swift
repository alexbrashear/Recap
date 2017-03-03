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

class Postcard: NSObject, NSCoding {
    enum Keys: String {
        case id = "id"
        case expectedDeliveryDate = "expected_delivery_date"
        case imageThumbnails = "imageThumbnails"
        case messageThumbnails = "messageThumbnails"
        case to = "to"
        case dateCreated = "date_created"
    }
    
    var id: String
    var expectedDeliveryDate: String
    var imageThumbnails: Thumbnails
    var messageThumbnails: Thumbnails
    var to: Address
    var dateCreated: String
    
    init(id: String, expectedDeliveryDate: String, imageThumbnails: Thumbnails, messageThumbnails: Thumbnails, to: Address, dateCreated: String) {
        self.id = id
        self.expectedDeliveryDate = expectedDeliveryDate
        self.imageThumbnails = imageThumbnails
        self.messageThumbnails = messageThumbnails
        self.to = to
        self.dateCreated = dateCreated
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: Keys.id.rawValue) as? String,
              let expectedDeliveryDate = aDecoder.decodeObject(forKey: Keys.expectedDeliveryDate.rawValue) as? String,
              let imageThumbnails = aDecoder.decodeObject(forKey: Keys.imageThumbnails.rawValue) as? Thumbnails,
              let messageThumbnails = aDecoder.decodeObject(forKey: Keys.messageThumbnails.rawValue) as? Thumbnails,
              let to = aDecoder.decodeObject(forKey: Keys.to.rawValue) as? Address,
              let dateCreated = aDecoder.decodeObject(forKey: Keys.dateCreated.rawValue) as? String else { return nil }
        self.init(id: id, expectedDeliveryDate: expectedDeliveryDate, imageThumbnails: imageThumbnails, messageThumbnails: messageThumbnails, to: to, dateCreated: dateCreated)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(expectedDeliveryDate, forKey: Keys.expectedDeliveryDate.rawValue)
        aCoder.encode(id, forKey: Keys.id.rawValue)
        aCoder.encode(imageThumbnails, forKey: Keys.imageThumbnails.rawValue)
        aCoder.encode(messageThumbnails, forKey: Keys.messageThumbnails.rawValue)
        aCoder.encode(to, forKey: Keys.to.rawValue)
        aCoder.encode(dateCreated, forKey: Keys.dateCreated.rawValue)
    }
}
