//
//  Postcard.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/20/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

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
    var expectedDeliveryDate: Date
    var imageThumbnails: Thumbnails
    var messageThumbnails: Thumbnails
    var to: Address
    var dateCreated: Date
    
    init(id: String, expectedDeliveryDate: Date, imageThumbnails: Thumbnails, messageThumbnails: Thumbnails, to: Address, dateCreated: Date) {
        self.id = id
        self.expectedDeliveryDate = expectedDeliveryDate
        self.imageThumbnails = imageThumbnails
        self.messageThumbnails = messageThumbnails
        self.to = to
        self.dateCreated = dateCreated
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: Keys.id.rawValue) as? String,
              let expectedDeliveryDate = aDecoder.decodeObject(forKey: Keys.expectedDeliveryDate.rawValue) as? Date,
              let imageThumbnails = aDecoder.decodeObject(forKey: Keys.imageThumbnails.rawValue) as? Thumbnails,
              let messageThumbnails = aDecoder.decodeObject(forKey: Keys.messageThumbnails.rawValue) as? Thumbnails,
              let to = aDecoder.decodeObject(forKey: Keys.to.rawValue) as? Address,
              let dateCreated = aDecoder.decodeObject(forKey: Keys.dateCreated.rawValue) as? Date else { return nil }
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
