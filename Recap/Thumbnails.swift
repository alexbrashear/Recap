//
//  Thumbnails.swift
//  Recap
//
//  Created by Alex Brashear on 6/6/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

struct Thumbnails {
    let small: URL
    let medium: URL
    let large: URL
    
    init(small: URL, medium: URL, large: URL) {
        self.small = small
        self.medium = medium
        self.large = large
    }
}
