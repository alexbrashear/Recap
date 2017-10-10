//
//  PaymentIconView.swift
//  Recap
//
//  Created by Alex Brashear on 10/10/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class PaymentIconView: UIView {
    
    private let label = UILabel()
    private var icon: UIView?
    
    init(icon: UIView, description: String) {
        super.init(frame: .zero)
        
        label.text = description
                
        addSubview(icon)
        addSubview(label)
        icon.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        icon.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        icon.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        icon.topAnchor.constraint(equalTo: topAnchor).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: icon, attribute: .trailing, multiplier: 1.0, constant: 10))
        
        self.icon = icon
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
