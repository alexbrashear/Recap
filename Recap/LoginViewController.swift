//
//  LoginViewController.swift
//  Recap
//
//  Created by Alex Brashear on 7/6/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var loginAction: (() -> Void)?
    var goToSignUpAction: (() -> Void)?
    
    @IBOutlet private var emailField: UITextField!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var passwordField: UITextField!
    @IBOutlet private var passwordLabel: UILabel!
    @IBOutlet private var logIn: UIButton!
    @IBOutlet private var goToSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.font = UIFont.openSansFont(ofSize: 20)
        passwordField.font = UIFont.openSansFont(ofSize: 20)
        passwordField.isSecureTextEntry = true
        
        emailLabel.font = UIFont.openSansBoldFont(ofSize: 12)
        passwordLabel.font = UIFont.openSansBoldFont(ofSize: 12)
        goToSignUp.titleLabel?.font = UIFont.openSansBoldFont(ofSize: 12)
        
        logIn.titleLabel?.font = UIFont.openSansBoldFont(ofSize: 20)
        logIn.backgroundColor = .rcpGoldenYellow
        logIn.layer.cornerRadius = 5
        logIn.clipsToBounds = true
    }
    
    @IBAction func didAttemptToLogin(_ sender: UIButton) {
        
    }
    
    @IBAction func didSwitchToSignUp(_ sender: UIButton) {
        
    }
}
