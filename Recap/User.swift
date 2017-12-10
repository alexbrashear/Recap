//
//  User.swift
//  Recap
//
//  Created by Alex Brashear on 4/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation
import Apollo

class User: NSObject, NSCoding {
    let id: GraphQLID
    let username: String
    let address: Address
    let remainingPhotos: Int
    let inviteCode: String
    let customerId: String?
    
    init(id: GraphQLID, username: String, address: Address, remainingPhotos: Int, inviteCode: String, customerId: String?) {
        self.address = address
        self.username = username
        self.remainingPhotos = remainingPhotos
        self.id = id
        self.inviteCode = inviteCode
        self.customerId = customerId
    }
    
    enum Keys: String {
        case username = "username"
        case address = "address"
        case remainingPhotos = "remainingPhotos"
        case id = "id"
        case inviteCode = "inviteCode"
        case customerId = "customerId"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let address = aDecoder.decodeObject(forKey: Keys.address.rawValue) as? Address,
            let id = aDecoder.decodeObject(forKey: Keys.id.rawValue) as? String,
            let username = aDecoder.decodeObject(forKey: Keys.username.rawValue) as? String,
            let inviteCode = aDecoder.decodeObject(forKey: Keys.inviteCode.rawValue) as? String else {
            assertionFailure("unable to decode User")
            return nil
        }
        
        let remainingPhotos = aDecoder.decodeInteger(forKey: Keys.remainingPhotos.rawValue)
        let customerId = aDecoder.decodeObject(forKey: Keys.customerId.rawValue) as? String
        
        self.init(id: id, username: username, address: address, remainingPhotos: remainingPhotos, inviteCode: inviteCode, customerId: customerId)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: Keys.id.rawValue)
        aCoder.encode(username, forKey: Keys.username.rawValue)
        aCoder.encode(address, forKey: Keys.address.rawValue)
        aCoder.encode(remainingPhotos, forKey: Keys.remainingPhotos.rawValue)
        aCoder.encode(inviteCode, forKey: Keys.inviteCode.rawValue)
        aCoder.encode(customerId, forKey: Keys.customerId.rawValue)
    }
}
