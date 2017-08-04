//
//  Film.swift
//  Recap
//
//  Created by Alex Brashear on 5/24/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

struct Photo {
    /// the image url that we upload to s3 - not lob
    let imageURL: URL
    let expectedDeliveryDate: String
    let thumbnails: Thumbnails
    
    init(imageURL: URL, expectedDeliveryDate: String, thumbnails: Thumbnails) {
        self.imageURL = imageURL
        self.expectedDeliveryDate = expectedDeliveryDate
        self.thumbnails = thumbnails
    }
}
