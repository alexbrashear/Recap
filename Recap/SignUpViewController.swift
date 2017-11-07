//
//  SignUpViewController.swift
//  Recap
//
//  Created by Alex Brashear on 7/8/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SafariServices

class SignUpViewController: UIViewController {
    @IBOutlet var header: UILabel!
    @IBOutlet var subHeader: UILabel!
    @IBOutlet var signupContainer: UIView!

    @IBOutlet var emailField: UITextField!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var passwordField: UITextField!
    @IBOutlet var passwordLabel: UILabel!
    @IBOutlet var submit: UIButton!
    @IBOutlet var goToLogin: UIButton!
    @IBOutlet var termsOfServiceLabel: UILabel!
    @IBOutlet var termsOfService: UIButton!
    
    var submitHandler: ((_ email: String, _ password: String) -> Void)?
    var goToLoginHandler: (() -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 75
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
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
        
        goToLogin.titleLabel?.font = UIFont.openSansBoldFont(ofSize: 12)
        goToLogin.titleLabel?.textColor = .white
        
        termsOfServiceLabel.font = UIFont.openSansSemiBoldFont(ofSize: 12)
        termsOfServiceLabel.textColor = .white
        
        termsOfService.titleLabel?.font = UIFont.openSansSemiBoldFont(ofSize: 12)
        termsOfService.titleLabel?.textColor = UIColor.rcpGoldenYellow
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        guard let email = emailField.text,
            let password = passwordField.text else { return }
        guard isValidEmail(email) else { return presentEmailAlert() }
        submitHandler?(email, password)
    }
    
    private func presentEmailAlert() {
        let alert = UIAlertController.okAlert(title: "Invalid Email", message: "Please enter a valid email address")
        present(alert, animated: true, completion: nil)
    }
    
    private func isValidEmail(_ testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func termsOfServiceTapped(_ sender: Any) {
        let svc = SFSafariViewController(url: StaticURLs.termsOfService, entersReaderIfAvailable: true)
        svc.delegate = self
        present(svc, animated: true, completion: nil)
    }
    
    @IBAction func goToLoginTapped(_ sender: UIButton) {
        goToLoginHandler?()
    }
}

extension SignUpViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
