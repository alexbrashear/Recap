//
//  ConnectFacebookViewController.swift
//  Recap
//
//  Created by Alex Brashear on 10/21/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ConnectFacebookViewController: UIViewController {
    
    @IBOutlet private var facebookCopy: UILabel!
    @IBOutlet private var facebookButton: UIButton!
    @IBOutlet private var doThisLater: UIButton!
    
    var connectFacebook: (() -> Void)?
    var doLater: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookCopy.font = UIFont.openSansFont(ofSize: 20)
        
        facebookButton.backgroundColor = .rcpGoldenYellow
        facebookButton.clipsToBounds = true
        facebookButton.layer.cornerRadius = 5
        facebookButton.titleLabel?.font = UIFont.openSansSemiBoldFont(ofSize: 20)
        facebookButton.on(.touchUpInside) { [weak self] _ in
            self?.connectFacebook?()
        }
        
        doThisLater.backgroundColor = .rcpGoldenYellow
        doThisLater.clipsToBounds = true
        doThisLater.layer.cornerRadius = 5
        doThisLater.titleLabel?.font = UIFont.openSansSemiBoldFont(ofSize: 20)
        doThisLater.on(.touchUpInside) { [weak self] _ in
            self?.doLater?()
        }
    }
}
