//
//  InputAddressView.swift
//  Recap
//
//  Created by Alex Brashear on 4/20/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

class InputAddressView: UIView, NibLoadable {

    @IBOutlet var nameContainer: UIView!
    @IBOutlet var addressContainer: UIView!
    @IBOutlet var aptContainer: UIView!
    @IBOutlet var cityContainer: UIView!
    @IBOutlet var stateContainer: UIView!
    @IBOutlet var zipContainer: UIView!
    
    let name = TextInputItem.loadFromNib()
    let address = TextInputItem.loadFromNib()
    let apt = TextInputItem.loadFromNib()
    let city = TextInputItem.loadFromNib()
    let state = TextInputItem.loadFromNib()
    let zip = TextInputItem.loadFromNib()

    override func awakeFromNib() {
        super.awakeFromNib()
        name.viewModel = TextInputItem.ViewModel(item: "NAME")
        nameContainer.addSubview(name)
        name.constrainToSuperview()
        
        address.viewModel = TextInputItem.ViewModel(item: "ADDRESS")
        addressContainer.addSubview(address)
        address.constrainToSuperview()
        
        apt.viewModel = TextInputItem.ViewModel(item: "APARTMENT")
        aptContainer.addSubview(apt)
        apt.constrainToSuperview()
        
        city.viewModel = TextInputItem.ViewModel(item: "CITY")
        cityContainer.addSubview(city)
        city.constrainToSuperview()
        
        state.viewModel = TextInputItem.ViewModel(item: "STATE")
        stateContainer.addSubview(state)
        state.constrainToSuperview()
        
        zip.viewModel = TextInputItem.ViewModel(item: "ZIP CODE")
        zipContainer.addSubview(zip)
        zip.constrainToSuperview()
    }
    
    func getAddress() -> Address {
        let name = self.name.value
        let addressLine1 = self.address.value
        let apt = self.apt.value
        let city = self.city.value
        let state = self.state.value
        let zip = self.zip.value
        
        return Address(id: "", name: name, line1: addressLine1, line2: apt, city: city, state: state, zip: zip)
    }
}
