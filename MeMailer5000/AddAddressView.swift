//
//  AddAddressView.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

typealias AddAddressTapHandler = (_ name: String, _ address: String, _ apt: String, _ city: String, _ state: String, _ zip: String) -> Void

typealias InvalidAddressInputHandler = () -> Void

protocol AddAddressViewModelProtocol: class {
    var addAddressTapHandler: AddAddressTapHandler? { get }
    
    var invalidAddressInputHandler: InvalidAddressInputHandler? { get }
}

class AddAddressView: UIView, NibLoadable {

    @IBOutlet private var name: UITextField!
    @IBOutlet private var address: UITextField!
    @IBOutlet private var apt: UITextField!
    @IBOutlet private var city: UITextField!
    @IBOutlet private var state: UITextField!
    @IBOutlet private var zip: UITextField!
    
    var viewModel: AddAddressViewModelProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func didTapDone(_ sender: UIButton) {
        guard let nameText = name.text,
              let addressText = address.text,
              let cityText = city.text,
              let stateText = state.text,
              let zipText = zip.text else {
                viewModel?.invalidAddressInputHandler?()
                return
        }
        let aptText = apt.text ?? ""
        
        viewModel?.addAddressTapHandler?(nameText, addressText, aptText, cityText, stateText, zipText)
    }
}
