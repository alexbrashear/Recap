//
//  PurchaseViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 6/1/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class PurchaseViewModel: PurchaseViewModelProtocol {
    var buyFilm: BuyFilmAction
    
    init(buyFilm: @escaping BuyFilmAction) {
        self.buyFilm = buyFilm
    }
}
