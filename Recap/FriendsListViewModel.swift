//
//  FriendsListViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 9/27/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation
import FacebookCore

typealias SendHandler = ([Friend]) -> Void

protocol FriendsListDisplayable {
    var title: String { get }
}

class FriendsListViewModel: FriendsListViewModelProtocol {
    
    private var selected = [Friend]()
    
    private var friendsSnapshot = [Section]()
    
    struct Section {
        let cells: [FriendsListDisplayable]
        let title: String?
        let type: FriendsListController.CellType
    }

    var topBarTapHandler: () -> Void
    private var sendHandler: SendHandler
    private var facebookHandler: () -> Void
    
    let friendsListProvider: FriendsListProvider
    let userController: UserController

    init(friendsListProvider: FriendsListProvider, userController: UserController, topBarTapHandler: @escaping () -> Void, sendHandler: @escaping SendHandler, facebookHandler: @escaping () -> Void) {
        self.friendsListProvider = friendsListProvider
        self.userController = userController
        self.topBarTapHandler = topBarTapHandler
        self.sendHandler = sendHandler
        self.facebookHandler = facebookHandler
        self.refreshFriendSnapshot()
    }
    
    func refreshFriendSnapshot() {
        var newFriends = [Section]()
        if let address = userController.user?.address {
            newFriends.append(Section(cells: [Friend(name: "\(address.name) (me)", address: address)], title: nil, type: .friend))
        }
        if !friendsListProvider.addedFriends.isEmpty {
            let addedFriends = Section(cells: friendsListProvider.addedFriends, title: "ADDED", type: .friend)
            newFriends.append(addedFriends)
        }
        if !friendsListProvider.recents.isEmpty {
            let recents = Section(cells: friendsListProvider.addedFriends, title: "RECENTS", type: .friend)
            newFriends.append(recents)
        }
        if !friendsListProvider.facebookFriends.isEmpty {
            let facebook = Section(cells: friendsListProvider.facebookFriends, title: "FACEBOOK", type: .friend)
            newFriends.append(facebook)
        } else if AccessToken.current != nil {
            let facebook = Section(cells: [FriendsListLink(title: "NO FRIENDS TO DISPLAY", action: {})], title: "FACEBOOK", type: .link)
            newFriends.append(facebook)
        } else {
            let facebook = Section(cells: [FriendsListLink(title: "TAP TO CONNECT FACEBOOK", action: facebookHandler)], title: "FACEBOOK", type: .link)
            newFriends.append(facebook)
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
            text = "\(text) \($0.name),"
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
    
    func titleForHeader(in section: Int) -> String? {
        return friendsSnapshot[section].title
    }
    
    func numberOfRows(in section: Int) -> Int {
        return friendsSnapshot[section].cells.count
    }
    
    func titleForRow(at indexPath: IndexPath) -> String {
        let group = friendsSnapshot[indexPath.section].cells
        return group[indexPath.row].title
    }
    
    func cellType(for indexPath: IndexPath) -> FriendsListController.CellType {
        return friendsSnapshot[indexPath.section].type
    }
    
    // mark - UITableViewDelegate
    
    func canSelect(indexPath: IndexPath) -> Bool {
        guard friendsSnapshot[indexPath.section].type != .link else { return true }
        guard let recapsRemaining = userController.user?.remainingPhotos else { return false }
        return selected.count < recapsRemaining
    }
    
    func didSelect(indexPath: IndexPath) {
        if let group = friendsSnapshot[indexPath.section].cells as? [Friend] {
            let friend = group[indexPath.row]
            selected.insert(friend, at: 0)
        } else if let group = friendsSnapshot[indexPath.section].cells as? [FriendsListLink] {
            group[indexPath.row].action()
        } else {
            assertionFailure()
        }
    }
    
    func didDeselect(indexPath: IndexPath) {
        if let group = friendsSnapshot[indexPath.section].cells as? [Friend] {
            let friend = group[indexPath.row]
            guard let index = selected.index(of: friend) else { return }
            selected.remove(at: index)
        } else if let group = friendsSnapshot[indexPath.section].cells as? [FriendsListLink] {
            group[indexPath.row].action()
        } else {
            assertionFailure()
        }
    }
    
    func didSend() {
        sendHandler(selected)
    }
}

class FriendsListLink: FriendsListDisplayable {
    var title: String
    var action: () -> Void
    
    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
}

extension Friend: FriendsListDisplayable {
    var title: String {
        return name
    }
}
