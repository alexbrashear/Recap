//
//  LinkCell.swift
//  Recap
//
//  Created by Alex Brashear on 11/5/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

class LinkCell: UITableViewCell, NibReusable {

    @IBOutlet var label: UILabel!
    
    struct ViewModel {
        let title: String
    }
    
    var viewModel: ViewModel? {
        didSet {
            label.text = viewModel?.title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.font = UIFont.openSansBoldFont(ofSize: 14)
    }
}
