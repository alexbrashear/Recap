//
//  Postcard.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/20/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class Postcard {
    var expectedDeliveryDate: String
    var imageThumbnails: [URL]
    var messageThumbnails: [URL]
    
    init(expectedDeliveryDate: String, imageThumbnails: [URL], messageThumbnails: [URL]) {
        self.expectedDeliveryDate = expectedDeliveryDate
        self.imageThumbnails = imageThumbnails
        self.messageThumbnails = messageThumbnails
    }
}
