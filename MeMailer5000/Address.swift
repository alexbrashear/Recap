//
//  Address.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 1/29/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import ValueCoding

struct Address {
    /// unique identifier - should be prefixed with "adr_"
    let identifier: String
    /// the name of the intended recipient at this address
    let name: String
    /// the address line 1
    let line1: String
    /// the address line 2
    let line2: String?
    /// the city of the address
    let city: String
    /// the state of the address
    let state: String
    /// the zip code of the address
    let zip: String
    /// the country of the address, defaults to "US"
    let country = "US"
}

extension Address: ValueCoding {
    typealias Coder = AddressCoder
}

final class AddressCoder: NSObject, NSCoding, CodingProtocol {
    enum Keys: String {
        case identifier
        case name
        case line1
        case line2
        case city
        case state
        case zip
        case country
    }
    
    let value: Address
    
    required init(_ v: Address) {
        value = v
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let identifier = aDecoder.decodeObject(forKey: Keys.identifier.rawValue) as? String,
              let name = aDecoder.decodeObject(forKey: Keys.name.rawValue) as? String,
              let line1 = aDecoder.decodeObject(forKey: Keys.line1.rawValue) as? String,
              let city = aDecoder.decodeObject(forKey: Keys.city.rawValue) as? String,
              let state = aDecoder.decodeObject(forKey: Keys.state.rawValue) as? String,
              let zip = aDecoder.decodeObject(forKey: Keys.zip.rawValue) as? String
        else {
            assertionFailure("unable to decode Address")
            return nil
        }
        
        let line2 = aDecoder.decodeObject(forKey: Keys.line2.rawValue) as? String
        
        value = Address(identifier: identifier, name: name, line1: line1, line2: line2, city: city, state: state, zip: zip)
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value.identifier, forKey: Keys.identifier.rawValue)
        aCoder.encode(value.name, forKey: Keys.name.rawValue)
        aCoder.encode(value.line1, forKey: Keys.line1.rawValue)
        aCoder.encode(value.line2, forKey: Keys.line2.rawValue)
        aCoder.encode(value.city, forKey: Keys.city.rawValue)
        aCoder.encode(value.state, forKey: Keys.state.rawValue)
        aCoder.encode(value.zip, forKey: Keys.zip.rawValue)
    }
}
