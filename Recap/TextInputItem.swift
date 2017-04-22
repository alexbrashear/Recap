//
//  TextInputItem.swift
//  Recap
//
//  Created by Alex Brashear on 4/20/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

class TextInputItem: UIView, NibLoadable {

    @IBOutlet private var input: UITextField!
    @IBOutlet private var item: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        input.font = UIFont.openSansFont(ofSize: 20.0)
        item.font = UIFont.openSansBoldFont(ofSize: 12.0)
        item.textColor = .clearBlue
    }

    struct ViewModel {
        let item: String
    }
    
    var viewModel: ViewModel? {
        didSet {
            item.text = viewModel?.item
        }
    }
    
    var value: String {
        return input.text ?? ""
    }
}
