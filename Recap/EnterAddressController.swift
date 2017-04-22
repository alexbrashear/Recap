//
//  EnterAddressController.swift
//  Recap
//
//  Created by Alex Brashear on 4/19/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class EnterAddressController: UIViewController {

    @IBOutlet var heading: UILabel!
    @IBOutlet var subHeading: UILabel!
    @IBOutlet var mainContainer: UIView!
    @IBOutlet var nextButton: UIButton!
    
    private let inputAddressView = InputAddressView.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainContainer.addSubview(inputAddressView)
        inputAddressView.constrainToSuperview()
        
        mainContainer.layer.cornerRadius = 3.0
        mainContainer.clipsToBounds = true
        
        nextButton.layer.cornerRadius = 5.0
        nextButton.clipsToBounds = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
