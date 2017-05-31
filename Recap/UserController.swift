//
//  UserController.swift
//  Recap
//
//  Created by Alex Brashear on 4/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class UserController {
    
    var user: User?
    
    init() {
        self.user = loadUser()
    }
    
    func setNewUser(address: Address) {
        let user = User(address: address)
        
        let collection = DatabaseController.Collection.user.rawValue
        let connection = DatabaseController.sharedInstance.newWritingConnection()
        connection.readWrite { transaction in
            transaction.setObject([user], forKey: "user", inCollection: collection)
        }
        
        self.user = user
    }
    
    private func loadUser() -> User? {
        var user: User?
        
        let collection = DatabaseController.Collection.user.rawValue
        let connection = DatabaseController.sharedInstance.newReadingConnection()
        connection.read { transaction in
            let users = transaction.object(forKey: "user", inCollection: collection) as? [User]
            user = users?.isEmpty ?? true ? nil : users?.first
        }
        return user
    }
}
