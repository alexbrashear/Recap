//
//  Film.swift
//  Recap
//
//  Created by Alex Brashear on 5/24/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

struct Photo {
    var id: String?
    /// the image url that we upload to s3 - not lob
    let imageURL: URL
    /// the intended recipients of the photo
    let recipients: [Address]
    /// the displayable date the photo was created
    let displayDateSent: String?
    
    init(id: String? = nil, imageURL: URL, recipients: [Address], displayDateSent: String? = nil) {
        self.id = id
        self.imageURL = imageURL
        self.recipients = recipients
        self.displayDateSent = displayDateSent
    }
}
