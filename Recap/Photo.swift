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
    
    init(imageURL: URL) {
        self.imageURL = imageURL
    }
}
