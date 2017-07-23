//
//  SignUpViewController.swift
//  Recap
//
//  Created by Alex Brashear on 7/8/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet var header: UILabel!
    @IBOutlet var subHeader: UILabel!
    @IBOutlet var signupContainer: UIView!

    @IBOutlet var emailField: UITextField!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var submit: UIButton!
    
    var submitHandler: ((_ email: String, _ password: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.font = UIFont.openSansSemiBoldFont(ofSize: 28)
        subHeader.font = UIFont.openSansSemiBoldFont(ofSize: 16)
        subHeader.textColor = .rcpGoldenYellow
        
        emailField.font = UIFont.openSansFont(ofSize: 20)
        emailField.textColor = UIColor.rcpDarkGrey
        passwordField.font = UIFont.openSansFont(ofSize: 20)
        passwordField.textColor = UIColor.rcpDarkGrey
        passwordField.isSecureTextEntry = true
        
        emailLabel.font = UIFont.openSansBoldFont(ofSize: 12)
        emailLabel.textColor = UIColor.rcpClearBlue
        passwordLabel.font = UIFont.openSansBoldFont(ofSize: 12)
        passwordLabel.textColor = UIColor.rcpClearBlue
        
        submit.titleLabel?.font = UIFont.openSansBoldFont(ofSize: 20)
        submit.titleLabel?.textColor = .white
        submit.backgroundColor = UIColor.rcpGoldenYellow
        submit.clipsToBounds = true
        submit.layer.cornerRadius = 5
        
        signupContainer.clipsToBounds = true
        signupContainer.layer.cornerRadius = 3
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        guard let email = emailField.text,
            let password = passwordField.text else { return }
        submitHandler?(email, password)
    }
    
}
