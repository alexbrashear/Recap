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
    
    var film: Film? {
        didSet {
            guard let film = film else { return }
            nextDelivery.text = "Next Delivery in \(film.daysTillNextDelivery) Days"
            deliveredCount.text = "\(film.photosSent) RECAPS SENT"
            purchaseDate.text = film.dateOfPurchase.filmPurchaseDateString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nextDelivery.font = UIFont.openSansFont(ofSize: 16)
        nextDelivery.textColor = .rcpDarkGrey
        deliveredCount.font = UIFont.openSansBoldFont(ofSize: 12)
        deliveredCount.textColor = .rcpBlueyGrey
        purchaseDate.font = UIFont.openSansFont(ofSize: 10)
        purchaseDate.textColor = .rcpBlueyGrey
    }
}
