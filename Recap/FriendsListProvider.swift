//
//  FriendsListProvider.swift
//  Recap
//
//  Created by Alex Brashear on 10/2/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class Friend: NSObject, NSCoding {
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    enum Keys: String {
        case name
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Keys.name.rawValue)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Keys.name.rawValue) as? String else {
            assertionFailure("unable to decode Friend")
            return nil
        }
        
        self.init(name: name)
    }
}

class FriendsListProvider {
    var addedFriends: [Friend]
    var recents: [Friend]
    var facebookFriends: [Friend]
    
    enum Keys: String {
        case addedFriends
    }
    
    init() {
        if let data = UserDefaults.standard.object(forKey: Keys.addedFriends.rawValue) as? Data {
            self.addedFriends = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Friend] ?? []
        } else {
            self.addedFriends = []
        }
        
        self.recents = []
        self.facebookFriends = []
    }
    
    func addFriend(_ friend: Friend) {
        addedFriends.append(friend)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: addedFriends)
        UserDefaults.standard.set(data, forKey: Keys.addedFriends.rawValue)
    }
}
