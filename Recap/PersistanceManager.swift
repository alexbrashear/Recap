//
//  KeychainManager.swift
//  Recap
//
//  Created by Alex Brashear on 7/28/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation
import KeychainAccess

class PersistanceManager {
    
    enum Keys: String {
        case user
        case password
        case token
        case customerId
    }
    
    private let keychain: Keychain
    
    var user: User? {
        get {
            if let data = UserDefaults.standard.object(forKey: Keys.user.rawValue) as? Data {
                return NSKeyedUnarchiver.unarchiveObject(with: data) as? User
            } else {
                return nil
            }
        }
        
        set {
            if let newValue = newValue {
                let data = NSKeyedArchiver.archivedData(withRootObject: newValue)
                UserDefaults.standard.set(data, forKey: Keys.user.rawValue)
            } else {
                UserDefaults.standard.set(nil, forKey: Keys.user.rawValue)
            }
        }
    }
    
    var password: String? {
        get {
            return keychain[Keys.password.rawValue]
        }
        
        set {
            keychain[Keys.password.rawValue] = newValue
        }
    }
    
    var token: String? {
        get {
            return keychain[Keys.token.rawValue]
        }
        
        set {
            keychain[Keys.token.rawValue] = newValue
        }
    }
    
    var customerId: String? {
        get {
            return keychain[Keys.customerId.rawValue]
        }
        
        set {
            keychain[Keys.customerId.rawValue] = newValue
        }
    }
    
    init() {
        self.keychain = Keychain(service: "com.recap.credentials")
    }
    
    func __clearCredentials() {
        user = nil
        password = nil
        token = nil
    }
}
