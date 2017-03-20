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
        if let addressJson = json["address"] as? [String: AnyObject] {
            guard json["message"] == nil else { return (nil, .notEnoughInformation) }
            return createAddress(json: addressJson, name: name)
        } else {
            return createAddress(json: json, name: name)
        }
    }
    
    private func createAddress(json: [String: AnyObject], name: String) -> (Address?, AddressError?) {
        guard let line1 = json[Address.Keys.line1.rawValue] as? String,
            let city  = json[Address.Keys.city.rawValue] as? String,
            let state = json[Address.Keys.state.rawValue] as? String,
            let zip   = json[Address.Keys.zip.rawValue] as? String else { return (nil, .unknownFailure) }
        let line2 = json[Address.Keys.line2.rawValue] as? String ?? ""
        return (Address(id: "", name: name, line1: line1, line2: line2, city: city, state: state, zip: zip), nil)
    }
}
