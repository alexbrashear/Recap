//
//  FilmRollCell.swift
//  Recap
//
//  Created by Alex Brashear on 5/21/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

final class FilmRollCell: UITableViewCell, NibReusable {

    @IBOutlet var nextDelivery: UILabel!
    @IBOutlet var deliveredCount: UILabel!
    @IBOutlet var purchaseDate: UILabel!
    @IBOutlet var scrollablePics: UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nextDelivery.text = "Next Delivery in 2 Days"
        nextDelivery.font = UIFont.openSansFont(ofSize: 16)
        nextDelivery.textColor = .rcpDarkGrey
        deliveredCount.text = "3 RECAPS SENT"
        deliveredCount.font = UIFont.openSansBoldFont(ofSize: 12)
        deliveredCount.textColor = .rcpBlueyGrey
        purchaseDate.text = "4/23/23"
        purchaseDate.font = UIFont.openSansFont(ofSize: 10)
        purchaseDate.textColor = .rcpBlueyGrey
        
        let stack = UIStackView()
        stack.addArrangedSubview(PreviewContainerView.loadFromNib())
        stack.addArrangedSubview(PreviewContainerView.loadFromNib())
        stack.addArrangedSubview(PreviewContainerView.loadFromNib())
        stack.addArrangedSubview(PreviewContainerView.loadFromNib())
        stack.addArrangedSubview(PreviewContainerView.loadFromNib())
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 10
        
        scrollablePics.addSubview(stack)
        stack.constrainToSuperview()
    }
}
