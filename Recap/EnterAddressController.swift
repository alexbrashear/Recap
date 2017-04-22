//
//  EnterAddressController.swift
//  Recap
//
//  Created by Alex Brashear on 4/19/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

typealias NextAction = (_ address: Address) -> Void

protocol EnterAddressViewModelProtocol: class {
    var nextAction: NextAction { get }
}

class EnterAddressController: UIViewController {

    @IBOutlet var heading: UILabel!
    @IBOutlet var subHeading: UILabel!
    @IBOutlet var mainContainer: UIView!
    @IBOutlet var nextButton: UIButton!
    
    private let inputAddressView = InputAddressView.loadFromNib()
    
    var viewModel: EnterAddressViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainContainer.addSubview(inputAddressView)
        inputAddressView.constrainToSuperview()
        
        mainContainer.layer.cornerRadius = 3.0
        mainContainer.clipsToBounds = true
        
        nextButton.layer.cornerRadius = 5.0
        nextButton.clipsToBounds = true
        
        nextButton.on(.touchUpInside) { [weak self] _ in
            guard let address = self?.inputAddressView.getAddress() else { return }
            self?.viewModel?.nextAction(address)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
