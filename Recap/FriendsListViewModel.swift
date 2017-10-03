//
//  FriendsListViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 9/27/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class FriendsListViewModel: FriendsListViewModelProtocol {
    
    private var selected = [Friend]()
    
    private var friendsSnapshot = [[Friend]]()

    var topBarTapHandler: () -> Void
    
    let friendsListProvider: FriendsListProvider
    let userController: UserController

    init(friendsListProvider: FriendsListProvider, userController: UserController, topBarTapHandler: @escaping () -> Void) {
        self.friendsListProvider = friendsListProvider
        self.userController = userController
        self.topBarTapHandler = topBarTapHandler
        self.refreshFriendSnapshot()
    }
    
    func refreshFriendSnapshot() {
        var newFriends = [[Friend]]()
        if !friendsListProvider.addedFriends.isEmpty {
            newFriends.append(friendsListProvider.addedFriends)
        }
        if !friendsListProvider.recents.isEmpty {
            newFriends.append(friendsListProvider.recents)
        }
        if !friendsListProvider.facebookFriends.isEmpty {
            newFriends.append(friendsListProvider.facebookFriends)
        }
        friendsSnapshot = newFriends
    }
    
    var shouldShowBottomBar: Bool {
        return !selected.isEmpty
    }
    
    var bottomBarText: String {
        guard shouldShowBottomBar else { return "" }
        var text = ""
        _ = selected.map {
            text = "\(text) \($0),"
        }
        return text.substring(to: text.index(before: text.endIndex))
    }
    
    var topBarText: String {
        guard let remainingPhotos = userController.user?.remainingPhotos else { return "Error retrieving your photos" }
        let remaining = remainingPhotos - selected.count
        if remaining == 0 {
            return "0 RECAPS LEFT - TAP TO GET MORE"
        } else if remaining == 1 {
            return "1 RECAP LEFT"
        } else {
            return "\(remaining) RECAPS LEFT"
        }
    }
    
    // mark - UITableViewDataSource
    
    var numberOfSections: Int {
        return friendsSnapshot.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        return friendsSnapshot[section].count
    }
    
    func titleForRow(at indexPath: IndexPath) -> String {
        let group = friendsSnapshot[indexPath.section]
        let friend = group[indexPath.row]
        return friend.name
    }
    
    // mark - UITableViewDelegate
    
    var canSelect: Bool {
        guard let recapsRemaining = userController.user?.remainingPhotos else { return false }
        return selected.count < recapsRemaining
    }
    
    func didSelect(indexPath: IndexPath) {
        let group = friendsSnapshot[indexPath.section]
        let friend = group[indexPath.row]
        selected.insert(friend, at: 0)
    }
    
    func didDeselect(indexPath: IndexPath) {
        let group = friendsSnapshot[indexPath.section]
        let friend = group[indexPath.row]
        guard let index = selected.index(of: friend) else { return }
        selected.remove(at: index)
    }
}
