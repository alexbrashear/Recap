//
//  PhotoItem.swift
//  Recap
//
//  Created by Alex Brashear on 7/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

class PhotoItem: UICollectionViewCell, Reusable {
    var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = false
        contentView.addSubview(imageView)
        imageView.backgroundColor = .red
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.constrainToSuperview()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
