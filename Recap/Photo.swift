//
//  Film.swift
//  Recap
//
//  Created by Alex Brashear on 5/24/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class Photo: NSObject, NSCoding {
    var imageURL: URL
    var dateTaken: Date
    var expectedDeliveryDate: Date?
    
    init(imageURL: URL, dateTaken: Date, expectedDeliveryDate: Date?) {
        self.imageURL = imageURL
        self.dateTaken = dateTaken
        self.expectedDeliveryDate = expectedDeliveryDate
    }
    
    enum Keys: String {
        case imageURL = "imageURL"
        case dateTaken = "dateTaken"
        case expectedDeliveryDate = "expectedDeliveryDate"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let imageURL = aDecoder.decodeObject(forKey: Keys.imageURL.rawValue) as? URL,
            let dateTaken = aDecoder.decodeObject(forKey: Keys.dateTaken.rawValue) as? Date else {
            assertionFailure("unable to decode Photo")
            return nil
        }
        
        let expectedDeliveryDate = aDecoder.decodeObject(forKey: Keys.expectedDeliveryDate.rawValue) as? Date
        
        self.init(imageURL: imageURL, dateTaken: dateTaken, expectedDeliveryDate: expectedDeliveryDate)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(imageURL, forKey: Keys.imageURL.rawValue)
        aCoder.encode(dateTaken, forKey: Keys.dateTaken.rawValue)
        aCoder.encode(expectedDeliveryDate, forKey: Keys.expectedDeliveryDate.rawValue)
    }
}
