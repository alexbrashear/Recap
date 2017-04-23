//
//  User.swift
//  Recap
//
//  Created by Alex Brashear on 4/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    let address: Address
    
    init(address: Address) {
        self.address = address
    }
    
    enum Keys: String {
        case address = "address"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let address = aDecoder.decodeObject(forKey: Keys.address.rawValue) as? Address else {
            assertionFailure("unable to decode Address")
            return nil
        }
        self.init(address: address)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(address, forKey: Keys.address.rawValue)
    }
}
