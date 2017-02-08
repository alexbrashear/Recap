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
        guard let addressJson = json["address"] as? [String:AnyObject],
              let line1 = addressJson[Address.Keys.line1.rawValue] as? String,
              let line2 = addressJson[Address.Keys.line2.rawValue] as? String,
              let city  = addressJson[Address.Keys.city.rawValue] as? String,
              let state = addressJson[Address.Keys.state.rawValue] as? String,
              let zip   = addressJson[Address.Keys.zip.rawValue] as? String else { return (nil, .unknownFailure) }
        return (Address(id: "", name: name, line1: line1, line2: line2, city: city, state: state, zip: zip), nil)
    }    
}
