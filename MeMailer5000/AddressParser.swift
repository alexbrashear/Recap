//
//  AddressParser.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 1/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

struct AddressParser {
    func parse(json: [String:String]?) -> Address? {
        return Address(name: "", line1: "", line2: "", city: "", state: "", zip: "")
    }
}
