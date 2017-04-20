//
//  WelcomeViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 4/19/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

typealias ContinueButtonAction = () -> Void

class WelcomeViewModel: WelcomeViewModelProtocol {
    var continueButtonAction: ContinueButtonAction
    
    var items: [WelcomeItem.ViewModel]
    
    init(continueButtonAction: @escaping ContinueButtonAction) {
        self.continueButtonAction = continueButtonAction
        items = [WelcomeItem.ViewModel(image: UIImage(), message: "SNAP A PHOTO"),
                 WelcomeItem.ViewModel(image: UIImage(), message: "PRESS SEND"),
                 WelcomeItem.ViewModel(image: UIImage(), message: "PHOTO ARRIVES IN THE MAIL")]
    }
}
