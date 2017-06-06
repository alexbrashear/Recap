//
//  Film.swift
//  Recap
//
//  Created by Alex Brashear on 5/24/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class Photo: NSObject, NSCoding {
    /// the image url that we upload to s3 - not lob
    var imageURL: URL
    var dateTaken: Date
    var expectedDeliveryDate: Date
    var thumbnails: Thumbnails
    
    init(imageURL: URL, dateTaken: Date, expectedDeliveryDate: Date, thumbnails: Thumbnails) {
        self.imageURL = imageURL
        self.dateTaken = dateTaken
        self.expectedDeliveryDate = expectedDeliveryDate
        self.thumbnails = thumbnails
    }
    
    enum Keys: String {
        case imageURL
        case dateTaken
        case expectedDeliveryDate
        case thumbnails
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let imageURL = aDecoder.decodeObject(forKey: Keys.imageURL.rawValue) as? URL,
            let dateTaken = aDecoder.decodeObject(forKey: Keys.dateTaken.rawValue) as? Date,
            let expectedDeliveryDate = aDecoder.decodeObject(forKey: Keys.expectedDeliveryDate.rawValue) as? Date,
            let thumbnails = aDecoder.decodeObject(forKey: Keys.thumbnails.rawValue) as? Thumbnails else {
            assertionFailure("unable to decode Photo")
            return nil
        }
        
        self.init(imageURL: imageURL, dateTaken: dateTaken, expectedDeliveryDate: expectedDeliveryDate, thumbnails: thumbnails)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(imageURL, forKey: Keys.imageURL.rawValue)
        aCoder.encode(dateTaken, forKey: Keys.dateTaken.rawValue)
        aCoder.encode(expectedDeliveryDate, forKey: Keys.expectedDeliveryDate.rawValue)
        aCoder.encode(thumbnails, forKey: Keys.thumbnails.rawValue)
    }
}
