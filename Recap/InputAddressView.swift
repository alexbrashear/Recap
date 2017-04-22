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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let name = TextInputItem.loadFromNib()
        name.viewModel = TextInputItem.ViewModel(item: "NAME")
        nameContainer.addSubview(name)
        name.constrainToSuperview()
        
        let address = TextInputItem.loadFromNib()
        address.viewModel = TextInputItem.ViewModel(item: "ADDRESS")
        addressContainer.addSubview(address)
        address.constrainToSuperview()
        
        let apt = TextInputItem.loadFromNib()
        apt.viewModel = TextInputItem.ViewModel(item: "APARTMENT")
        aptContainer.addSubview(apt)
        apt.constrainToSuperview()
        
        let city = TextInputItem.loadFromNib()
        city.viewModel = TextInputItem.ViewModel(item: "CITY")
        cityContainer.addSubview(city)
        city.constrainToSuperview()
        
        let state = TextInputItem.loadFromNib()
        state.viewModel = TextInputItem.ViewModel(item: "STATE")
        stateContainer.addSubview(state)
        state.constrainToSuperview()
        
        let zip = TextInputItem.loadFromNib()
        zip.viewModel = TextInputItem.ViewModel(item: "ZIP CODE")
        zipContainer.addSubview(zip)
        zip.constrainToSuperview()
    }
}
