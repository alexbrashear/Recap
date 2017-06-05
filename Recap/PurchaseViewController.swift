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
    
    let film = Film(capacity: 10)

    @IBOutlet private var message: UILabel!
    @IBOutlet private var disclaimer: UILabel!
    @IBOutlet private var productDescription: UILabel!
    @IBOutlet private var decrement: UIButton!
    @IBOutlet private var increment: UIButton!
    @IBOutlet private var filmCount: UILabel!
    @IBOutlet private var individualPrice: UILabel!
    @IBOutlet private var totalPrice: UILabel!
    @IBOutlet private var buyFilm: UIButton!
    
    var viewModel: PurchaseViewModelProtocol?
    
    private var currentFilmCount: Int = 1
    private var filmPrice: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filmCount.text = "\(1)"
        totalPrice.text = "$\(filmPrice)"
        
        message.font = UIFont.openSansFont(ofSize: 16)
        disclaimer.font = UIFont.openSansFont(ofSize: 10)
        productDescription.font = UIFont.openSansSemiBoldFont(ofSize: 16)
        individualPrice.font = UIFont.openSansBoldFont(ofSize: 12)
        totalPrice.font = UIFont.openSansFont(ofSize: 20)
        filmCount.font = UIFont.openSansBoldFont(ofSize: 20)
        
        buyFilm.titleLabel?.font = UIFont.openSansBoldFont(ofSize: 20)
        buyFilm.on(.touchUpInside) { [unowned self] _ in
            self.viewModel?.buyFilm(self.film)
        }
        
        increment.on(.touchUpInside) { [unowned self] _ in
            self.syncSetCurrentFilmCount(increment: true)
        }
        decrement.on(.touchUpInside) { [unowned self] _ in
            self.syncSetCurrentFilmCount(increment: false)
        }
    }
    
    func syncSetCurrentFilmCount(increment: Bool) {
        synced(self) {
            let count = increment ? self.currentFilmCount + 1 : self.currentFilmCount - 1
            guard count > 0 else { return }
            filmCount.text = "\(count)"
            totalPrice.text = "$\(count * filmPrice)"
            self.currentFilmCount = count
        }
    }
}

func synced(_ lock: Any, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
