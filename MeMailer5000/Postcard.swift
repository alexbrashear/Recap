//
//  Postcard.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 1/30/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

struct Postcard {
    /// NOT SURE WHAT THIS DOES
    let description: String?
    /// A 4.25"x6.25", 6.25"x9.25", or 6.25"x11.25" image to use as the front of the postcard. 
    /// This can be a URL, local file, or an HTML string. Supported file types are PDF, PNG, and JPEG.
    let front: String
    /// the address of the recipient
    let to: Address
    /// the optional return address
    let from: Address?
    /// A 4.25"x6.25", 6.25"x9.25", or 6.25"x11.25" image to use as the back of the postcard, 
    /// supplied as a URL, local file, or HTML string.
    ///
    /// - note: either `message` or `back` is required.
    let back: String?
    /// Max of 350 characters to be included on the back of postcard.
    ///
    /// - note: either `message` or `back` is required.
    let message: String?
    /// Specifies the size of the postcard. Must be either 4x6, 6x9, or 6x11. Defaults to 4x6. 
    ///
    /// - note: Only 4x6 postcards can be sent to international destinations.
    let size = "4x6"
}
