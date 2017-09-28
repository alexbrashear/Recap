//
//  FriendsListTopBar.swift
//  Recap
//
//  Created by Alex Brashear on 9/27/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class FriendsListTopBar: UIView {
    var label = UILabel(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .rcpPaleGold

        addSubview(label)
        label.constrainToSuperview()
        label.font = UIFont.openSansBoldFont(ofSize: 14)
        label.textAlignment = .center
    }
    
    func setText(_ text: String) {
        label.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
