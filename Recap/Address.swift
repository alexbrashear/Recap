//
//  Address.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 1/29/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class Address: NSObject, NSCoding {
    /// the unique identifier of the address
    var id: String
    /// the name of the intended recipient at this address
    let name: String
    /// the address line 1
    let primaryLine: String
    /// the address line 2
    let secondaryLine: String
    /// the city of the address
    let city: String
    /// the state of the address
    let state: String
    /// the zip code of the address
    let zip: String
    /// the country of the address, defaults to "US"
    let country = "US"
    
    init(id: String, name: String, primaryLine: String, secondaryLine: String, city: String, state: String, zip: String) {
        self.id = id
        self.name = name
        self.primaryLine = primaryLine
        self.secondaryLine = secondaryLine
        self.city = city
        self.state = state
        self.zip = zip
    }
    
    enum Keys: String {
        case id      = "id"
        case name    = "name"
        case primaryLine   = "primary_line"
        case secondaryLine   = "secondary_line"
        case city = "city"
        case state = "state"
        case zipcode = "zip_code"
        case country = "country"
        // These are still here for the postcards API, address verification
        // no longer uses these
        case line1   = "address_line1"
        case line2   = "address_line2"
        case addressCity    = "address_city"
        case addressState   = "address_state"
        case addressZip     = "address_zip"
        case addressCountry = "address_country"
    }
    
    var firstName: String {
        let names = name.components(separatedBy: " ")
        if !names.isEmpty {
            return names[0]
        } else {
            return ""
        }
    }
    
    var lastName: String {
        let names = name.components(separatedBy: " ")
        if names.count >= 2 {
            return names[names.count - 1]
        } else {
            return ""
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: Keys.id.rawValue) as? String,
            let name = aDecoder.decodeObject(forKey: Keys.name.rawValue) as? String,
            let primaryLine = aDecoder.decodeObject(forKey: Keys.primaryLine.rawValue) as? String,
            let secondaryLine = aDecoder.decodeObject(forKey: Keys.secondaryLine.rawValue) as? String,
            let city = aDecoder.decodeObject(forKey: Keys.city.rawValue) as? String,
            let state = aDecoder.decodeObject(forKey: Keys.state.rawValue) as? String,
            let zip = aDecoder.decodeObject(forKey: Keys.zipcode.rawValue) as? String
            else {
                assertionFailure("unable to decode Address")
                return nil
        }
        self.init(id: id, name: name, primaryLine: primaryLine, secondaryLine: secondaryLine, city: city, state: state, zip: zip)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Keys.id.rawValue)
        aCoder.encode(name, forKey: Keys.name.rawValue)
        aCoder.encode(primaryLine, forKey: Keys.primaryLine.rawValue)
        aCoder.encode(secondaryLine, forKey: Keys.secondaryLine.rawValue)
        aCoder.encode(city, forKey: Keys.city.rawValue)
        aCoder.encode(state, forKey: Keys.state.rawValue)
        aCoder.encode(zip, forKey: Keys.zipcode.rawValue)
    }
    
    /// Returns a string that can be used in the body of an http request
    ///
    /// - Parameter name: the parent object (e.g. "to[address_line1]=132 st marks")
    /// - returns: the encoded string
    func bodyString(withParent parent: String) -> String {
        return "\(parent)[\(Address.Keys.name.rawValue)]=\(name)&" +
               "\(parent)[\(Address.Keys.line1.rawValue)]=\(primaryLine)&" +
               "\(parent)[\(Address.Keys.line2.rawValue)]=\(secondaryLine)&" +
               "\(parent)[\(Address.Keys.addressCity.rawValue)]=\(city)&" +
               "\(parent)[\(Address.Keys.addressState.rawValue)]=\(state)&" +
               "\(parent)[\(Address.Keys.addressZip.rawValue)]=\(zip)&" +
               "\(parent)[\(Address.Keys.addressCountry.rawValue)]=\(country)"
    }
}
