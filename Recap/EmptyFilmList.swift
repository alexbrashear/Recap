//
//  EmptyFilmList.swift
//  Recap
//
//  Created by Alex Brashear on 6/7/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

class EmptyFilmList: UIView, NibLoadable {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        title.font = UIFont.openSansSemiBoldFont(ofSize: 16.0)
        title.textColor = .rcpClearBlue
        subtitle.font = UIFont.openSansFont(ofSize: 12.0)
        subtitle.textColor = .rcpBlueyGrey
    }
}
