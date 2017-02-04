//
//  AddressCell.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet private var title: UILabel!
    @IBOutlet private var subtitle: UILabel!
    
    struct ViewModel {
        let title: String
        let subtitle: String
    }
    
    var viewModel: ViewModel? {
        didSet {
            title.text = viewModel?.title
            subtitle.text = viewModel?.subtitle
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
