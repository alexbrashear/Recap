//
//  InviteCodeController.swift
//  Recap
//
//  Created by Alex Brashear on 10/29/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class InviteCodeController: ManagedKeyboardViewController {
    @IBOutlet private var inviteCodeField: UITextField!
    @IBOutlet private var inviteCodeLabel: UILabel!
    @IBOutlet private var submit: UIButton!
    @IBOutlet private var descriptionLabel: UILabel!
    
    var submitAction: ((_ code: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteCodeField.font = UIFont.openSansFont(ofSize: 26)
        inviteCodeLabel.font = UIFont.openSansBoldFont(ofSize: 12)
        submit.titleLabel?.font = UIFont.openSansBoldFont(ofSize: 20)
        submit.clipsToBounds = true
        submit.layer.cornerRadius = 5
        descriptionLabel.font = UIFont.openSansFont(ofSize: 16)
        
        submit.on(.touchUpInside) { [weak self] _ in
            guard let code = self?.inviteCodeField.text else { return }
            self?.submitAction?(code)
        }
    }
}
