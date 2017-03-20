//
//  String+DateFormatting.swift
//  Recap
//
//  Created by Alex Brashear on 3/19/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

extension String {
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
    
    var dateFromStandard: Date? {
        return Date.basicFormatter.date(from: self)
    }
}

