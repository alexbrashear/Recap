//
//  EnterAddressViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 4/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class EnterAddressViewModel: EnterAddressViewModelProtocol {
    var nextAction: NextAction
    var backAction: () -> Void
    var heading: NSAttributedString
    var subheading: NSAttributedString
    var buttonText: NSAttributedString
    
    init(headingText: String, subheadingText: String, buttonText: String, backAction: @escaping () -> Void, nextAction: @escaping NextAction) {
        self.nextAction = nextAction
        self.backAction = backAction
        self.buttonText = NSAttributedString(string: buttonText, attributes: [
            NSFontAttributeName: UIFont.openSansBoldFont(ofSize: 20),
            NSForegroundColorAttributeName: UIColor.white])
        self.heading = NSAttributedString(string: headingText, attributes: [
            NSFontAttributeName: UIFont.openSansSemiBoldFont(ofSize: 20),
            NSForegroundColorAttributeName: UIColor.white])
        self.subheading = NSAttributedString(string: subheadingText, attributes: [
            NSFontAttributeName: UIFont.openSansSemiBoldFont(ofSize: 20),
            NSForegroundColorAttributeName: UIColor.rcpGoldenYellow])
    }
}

class EnterAddressSignupViewModel: EnterAddressViewModel {
    init(backAction: @escaping () -> Void, nextAction: @escaping NextAction) {
        super.init(headingText: "Where do you live?", subheadingText: "We'll send your Recaps here", buttonText: "Next", backAction: backAction, nextAction: nextAction)
    }
}

class EnterAddressNewFriendViewModel: EnterAddressViewModel {
    init(friendsListProvider: FriendsListProvider, backAction: @escaping () -> Void) {
        let weakBackAction: (() -> Void)? = backAction
        super.init(headingText: "Add a friend", subheadingText: "We'll send their recaps here", buttonText: "Save", backAction: backAction, nextAction: { [weak friendsListProvider] address in
            friendsListProvider?.addFriend(Friend(name: address.name, address: address))
            weakBackAction?()
        })
    }
}
