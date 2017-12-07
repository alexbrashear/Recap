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
        guard let primaryLine = json[Address.Keys.primaryLine.rawValue] as? String,
        let components = json["components"] as? [String: AnyObject],
            let (city, state, zip) = parseComponents(json: components) else { return (nil, .unknownFailure) }
        let secondaryLine = json[Address.Keys.secondaryLine.rawValue] as? String ?? ""
        return (Address(id: "", name: name, primaryLine: primaryLine, secondaryLine: secondaryLine, city: city, state: state, zip: zip), nil)
    }
    
    private func parseComponents(json: [String: AnyObject]) -> (String, String, String)? {
        guard let city  = json[Address.Keys.city.rawValue] as? String,
            let state = json[Address.Keys.state.rawValue] as? String,
            let zip   = json[Address.Keys.zipcode.rawValue] as? String else { return nil }
        return (city, state, zip)
    }
}
