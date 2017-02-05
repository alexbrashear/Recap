//
//  AddressParser.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 1/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

struct AddressParser {
    func parse(json: [String:AnyObject], name: String) -> (Address?, AddressError?) {
        guard json["message"] == nil else { return (nil, .notEnoughInformation) }
        guard let line1 = json[AddressCoder.Keys.line1.rawValue] as? String,
              let line2 = json[AddressCoder.Keys.line2.rawValue] as? String,
              let city  = json[AddressCoder.Keys.city.rawValue] as? String,
              let state = json[AddressCoder.Keys.state.rawValue] as? String,
              let zip   = json[AddressCoder.Keys.zip.rawValue] as? String else { return (nil, .unknownFailure) }
        return (Address(id: "", name: name, line1: line1, line2: line2, city: city, state: state, zip: zip), nil)
    }    
}
