//
//  WelcomeItem.swift
//  Recap
//
//  Created by Alex Brashear on 4/19/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable
import OpenSans

class WelcomeItem: UIView, NibLoadable {

    @IBOutlet var icon: UIImageView!
    @IBOutlet var direction: UILabel!
    
    struct ViewModel {
        let image: UIImage
        let message: String
    }
    
    var viewModel: ViewModel? {
        didSet {
            icon.image = viewModel?.image
            direction.text = viewModel?.message
            direction.font = UIFont.openSansBoldFont(ofSize: 16.0)
        }
    }
}
