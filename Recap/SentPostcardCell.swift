//
//  SentPostcardCell.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 3/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class SentPostcardCell: UITableViewCell {

    @IBOutlet var name: UILabel!
    @IBOutlet var expectedDelivery: UILabel!
    @IBOutlet var postcard: UIImageView!
    
    struct ViewModel {
        let name: String
        let expectedDelivery: String
        let postcardThumbnail: UIImage?
    }
    
    var viewModel: ViewModel? {
        didSet {
            name.text = viewModel?.name
            expectedDelivery.text = viewModel?.expectedDelivery
            postcard.image = viewModel?.postcardThumbnail
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView?.contentMode = .scaleAspectFit
    }
}
