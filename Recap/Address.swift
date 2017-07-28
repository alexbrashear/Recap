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
    let line1: String
    /// the address line 2
    let line2: String
    /// the city of the address
    let city: String
    /// the state of the address
    let state: String
    /// the zip code of the address
    let zip: String
    /// the country of the address, defaults to "US"
    let country = "US"
    
    init(id: String, name: String, line1: String, line2: String, city: String, state: String, zip: String) {
        self.id = id
        self.name = name
        self.line1 = line1
        self.line2 = line2
        self.city = city
        self.state = state
        self.zip = zip
    }
    
    enum Keys: String {
        case id      = "id"
        case name    = "name"
        case line1   = "address_line1"
        case line2   = "address_line2"
        case city    = "address_city"
        case state   = "address_state"
        case zip     = "address_zip"
        case country = "address_country"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: Keys.id.rawValue) as? String,
            let name = aDecoder.decodeObject(forKey: Keys.name.rawValue) as? String,
            let line1 = aDecoder.decodeObject(forKey: Keys.line1.rawValue) as? String,
            let line2 = aDecoder.decodeObject(forKey: Keys.line2.rawValue) as? String,
            let city = aDecoder.decodeObject(forKey: Keys.city.rawValue) as? String,
            let state = aDecoder.decodeObject(forKey: Keys.state.rawValue) as? String,
            let zip = aDecoder.decodeObject(forKey: Keys.zip.rawValue) as? String
            else {
                assertionFailure("unable to decode Address")
                return nil
        }
        self.init(id: id, name: name, line1: line1, line2: line2, city: city, state: state, zip: zip)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Keys.id.rawValue)
        aCoder.encode(name, forKey: Keys.name.rawValue)
        aCoder.encode(line1, forKey: Keys.line1.rawValue)
        aCoder.encode(line2, forKey: Keys.line2.rawValue)
        aCoder.encode(city, forKey: Keys.city.rawValue)
        aCoder.encode(state, forKey: Keys.state.rawValue)
        aCoder.encode(zip, forKey: Keys.zip.rawValue)
    }
    
    /// Returns a string that can be used in the body of an http request
    ///
    /// - Parameter name: the parent object (e.g. "to[address_line1]=132 st marks")
    /// - returns: the encoded string
    func bodyString(withParent parent: String) -> String {
        return "\(parent)[\(Address.Keys.name.rawValue)]=\(name)&" +
               "\(parent)[\(Address.Keys.line1.rawValue)]=\(line1)&" +
               "\(parent)[\(Address.Keys.line2.rawValue)]=\(line2)&" +
               "\(parent)[\(Address.Keys.city.rawValue)]=\(city)&" +
               "\(parent)[\(Address.Keys.state.rawValue)]=\(state)&" +
               "\(parent)[\(Address.Keys.zip.rawValue)]=\(zip)&" +
               "\(parent)[\(Address.Keys.country.rawValue)]=\(country)"
    }
}
