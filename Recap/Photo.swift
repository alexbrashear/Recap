//
//  Film.swift
//  Recap
//
//  Created by Alex Brashear on 5/24/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class Photo: NSObject, NSCoding {
    var image: UIImage
    var dateTaken: Date
    var expectedDeliveryDate: Date?
    
    init(image: UIImage, dateTaken: Date, expectedDeliveryDate: Date?) {
        self.image = image
        self.dateTaken = dateTaken
        self.expectedDeliveryDate = expectedDeliveryDate
    }
    
    enum Keys: String {
        case image = "image"
        case dateTaken = "dateTaken"
        case expectedDeliveryDate = "expectedDeliveryDate"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let image = aDecoder.decodeObject(forKey: Keys.image.rawValue) as? UIImage,
            let dateTaken = aDecoder.decodeObject(forKey: Keys.dateTaken.rawValue) as? Date else {
            assertionFailure("unable to decode Photo")
            return nil
        }
        
        let expectedDeliveryDate = aDecoder.decodeObject(forKey: Keys.expectedDeliveryDate.rawValue) as? Date
        
        self.init(image: image, dateTaken: dateTaken, expectedDeliveryDate: expectedDeliveryDate)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: Keys.image.rawValue)
        aCoder.encode(dateTaken, forKey: Keys.dateTaken.rawValue)
        aCoder.encode(expectedDeliveryDate, forKey: Keys.expectedDeliveryDate.rawValue)
    }
}
