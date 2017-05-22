//
//  PreviewContainerView.swift
//  Recap
//
//  Created by Alex Brashear on 5/21/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

class PreviewContainerView: UIView, NibLoadable {
    
    @IBOutlet var preview: UIImageView!
    @IBOutlet var status: UIImageView!
    
    struct ViewModel {
        let preview: UIImage
        let status: UIImage
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        preview.backgroundColor = .purple
        status.image = UIImage(named: "RCPCheckmark")
    }
    
    var viewModel: ViewModel? {
        didSet {
            preview.image = viewModel?.preview
            status.image = viewModel?.status
        }
    }
}
