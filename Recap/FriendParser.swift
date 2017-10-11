//
//  FriendParser.swift
//  Recap
//
//  Created by Alex Brashear on 10/10/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class FriendParser {
    
    enum Key: String {
        case data
        case id
        case name
    }
    
    func parse(data: [String: Any]) -> [Friend] {
        guard let list = data[Key.data.rawValue] as? [[String: Any]] else { return [] }
        var friends = [Friend]()
        for friend in list {
            if let parsedFriend = parseFriend(data: friend) {
                friends.append(parsedFriend)
            }
        }
        return friends
    }
    
    private func parseFriend(data: [String: Any]) -> Friend? {
        guard let name = data[Key.name.rawValue] as? String,
              let id = data[Key.id.rawValue] as? String else {
                return nil
        }
        return Friend(name: name, facebookId: id)
    }
}
