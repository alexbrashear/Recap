//
//  AddAddressController.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class AddAddressController: UIViewController {
    
    @IBOutlet fileprivate var nameField: UITextField!
    @IBOutlet fileprivate var addressField: UITextField!
    @IBOutlet fileprivate var aptField: UITextField!
    @IBOutlet fileprivate var cityField: UITextField!
    @IBOutlet fileprivate var stateField: UITextField!
    @IBOutlet fileprivate var zipField: UITextField!
    
    fileprivate var tap: UIGestureRecognizer?
    
    private let addressProvider = AddressProvider()
    
    var reloadAddresses: (() -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
        dismissKeyboard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add an address"
        tap = UITapGestureRecognizer(target: self, action: .dismissKeyboard)
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancel
    }
    
    func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapDone(_ sender: UIButton) {
        dismissKeyboard()
        guard let name = nameField.text,
            let address = addressField.text,
            let city = cityField.text,
            let state = stateField.text,
            let zip = zipField.text else {
                presentAlert(withTitle: "Error", message: "Some required fields were not entered.")
                return
        }
        let apt = aptField.text ?? ""
        
        addressProvider.verify(name: name, line1: address, line2: apt, city: city, state: state, zip: zip) { [weak self] address, error in
            if let error = error {
                self?.presentAlert(withTitle: error.localizedTitle, message: error.localizedDescription)
            } else {
                guard let address = address else {
                    self?.presentAlert(withTitle: AddressError.unknownFailure.localizedTitle, message: AddressError.unknownFailure.localizedDescription)
                    return
                }
                let persister = Persister()
                let success = persister.save(address: address)
                if !success {
                    self?.presentAlert(withTitle: "Error", message: "Address was found but could not be saved")
                } else {
                    self?.reloadAddresses?()
                }
            }
        }
    }
    
    func presentAlert(withTitle: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - Keyboard

extension AddAddressController {
    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: .keyboardWillHide, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        guard let tap = self.tap else { return }
        view.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        guard let tap = self.tap else { return }
        view.removeGestureRecognizer(tap)
    }
    
    @objc fileprivate func dismissKeyboard() {
        nameField.resignFirstResponder()
        addressField.resignFirstResponder()
        aptField.resignFirstResponder()
        cityField.resignFirstResponder()
        stateField.resignFirstResponder()
        zipField.resignFirstResponder()
    }
}

private extension Selector {
    
    static let dismissKeyboard = #selector(AddAddressController.dismissKeyboard)
    
    static let keyboardWillShow = #selector(AddAddressController.keyboardWillShow(_:))
    static let keyboardWillHide = #selector(AddAddressController.keyboardWillHide(_:))
}
