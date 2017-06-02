//
//  PurchaseViewController.swift
//  Recap
//
//  Created by Alex Brashear on 5/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

typealias BuyFilmAction = (Film) -> Void

protocol PurchaseViewModelProtocol: class {
    var buyFilm: BuyFilmAction { get }
}

class PurchaseViewController: UIViewController {
    
    let film = Film(capacity: 5)

    @IBOutlet private var buyFilm: UIButton!
    
    var viewModel: PurchaseViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buyFilm.on(.touchUpInside) { [unowned self] _ in
            self.viewModel?.buyFilm(self.film)
            print("test")
        }
    }
}
