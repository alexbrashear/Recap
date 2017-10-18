//
//  FriendsListProvider.swift
//  Recap
//
//  Created by Alex Brashear on 10/2/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FacebookCore
import FacebookLogin

class Friend: NSObject, NSCoding {
    var name: String
    var facebookId: String?
    var address: Address?
    
    var isFacebook: Bool {
        return facebookId != nil
    }
    
    init(name: String, facebookId: String? = nil, address: Address? = nil) {
        self.name = name
        self.facebookId = facebookId
        self.address = address
    }
    
    enum Keys: String {
        case name
        case facebookId
        case address
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Keys.name.rawValue)
        aCoder.encode(facebookId, forKey: Keys.facebookId.rawValue)
        aCoder.encode(address, forKey: Keys.address.rawValue)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: Keys.name.rawValue) as? String else {
            assertionFailure("unable to decode Friend")
            return nil
        }
        let facebookId = aDecoder.decodeObject(forKey: Keys.facebookId.rawValue) as? String
        let address = aDecoder.decodeObject(forKey: Keys.address.rawValue) as? Address
        
        self.init(name: name, facebookId: facebookId, address: address)
    }
}

struct FriendNotification {
    static let facebookUpdated = Notification.Name("facebookUpdated")
}

class FriendsListProvider {
    var addedFriends: [Friend]
    var recents: [Friend]
    var facebookFriends: [Friend]
    
    enum Keys: String {
        case addedFriends
    }
    
    private let parser = FriendParser()
    
    init() {
        if let data = UserDefaults.standard.object(forKey: Keys.addedFriends.rawValue) as? Data {
            self.addedFriends = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Friend] ?? []
        } else {
            self.addedFriends = []
        }
        
        self.recents = []
        self.facebookFriends = []
        
        fetchFacebookFriends()
        
        NotificationCenter.default.addObserver(forName: UserNotification.userConnectedFacebook, object: nil, queue: .current) { [weak self] _ in
            self?.fetchFacebookFriends()
        }
    }
    
    func addFriend(_ friend: Friend) {
        addedFriends.append(friend)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: addedFriends)
        UserDefaults.standard.set(data, forKey: Keys.addedFriends.rawValue)
    }
    
    func fetchFacebookFriends() {
        guard let userId = AccessToken.current?.userId else { return }
        let request = FBSDKGraphRequest(graphPath: "/\(userId)/friends", parameters: [:], httpMethod: "GET")
        _ = request?.start(completionHandler: { [weak self] connection, result, error in
            guard let data = result as? [String: Any] else { return }
            if let friends = self?.parser.parse(data: data) {
                self?.facebookFriends = friends
                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: FriendNotification.facebookUpdated, object: nil, userInfo: nil)
                }
            }
        })
    }
}
