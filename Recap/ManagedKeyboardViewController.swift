//
//  ManagedKeyboardViewController.swift
//  Recap
//
//  Created by Alex Brashear on 10/29/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ManagedKeyboardViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 75
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
}
