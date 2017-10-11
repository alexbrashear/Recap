//
//  FriendsListBottomBar.swift
//  Recap
//
//  Created by Alex Brashear on 9/26/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class FriendsListBottomBar: UIView {
    
    private var names = UILabel()
    private var icon = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(names)
        addSubview(icon)
        
        names.font = UIFont.openSansSemiBoldFont(ofSize: 16)
        names.textColor = .white
        
        backgroundColor = .rcpClearBlue
        
        names.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: names, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 20))
        addConstraint(NSLayoutConstraint(item: names, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: names, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -10))
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.heightAnchor.constraint(equalToConstant: 40).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        addConstraint(NSLayoutConstraint(item: icon, attribute: .centerY, relatedBy: .equal, toItem: names, attribute: .centerY, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: icon, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -10))
        addConstraint(NSLayoutConstraint(item: names, attribute: .trailing, relatedBy: .equal, toItem: icon, attribute: .leading, multiplier: 1.0, constant: -10))
        
        let imageView = UIImageView(image: UIImage(named: "iconSend"))
        icon.addSubview(imageView)
        imageView.constrainToSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        names.text = text
    }
    
    func setAction(_ action: @escaping () -> Void) {
        icon.on(.touchUpInside) { _ in
            action()
        }
    }
}
