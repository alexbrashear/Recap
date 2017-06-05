//
//  Purchase.swift
//  Recap
//
//  Created by Alex Brashear on 5/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import PKHUD

typealias UpdateFilmCount = (Int) -> Void

extension RootFlowCoordinator {
    func presentPurchaseController(from presentingViewController: UIViewController, updateFilmCount: @escaping UpdateFilmCount) {
        guard let vc = R.storyboard.purchase.purchaseViewController() else { return }
        let nc = UINavigationController(rootViewController: vc)
        configureNavigationController(nc: nc)
        configurePurchaseViewController(vc: vc, nc: nc, updateFilmCount: updateFilmCount)
        presentingViewController.present(nc, animated: true, completion: nil)
    }
    
    private func configurePurchaseViewController(vc: PurchaseViewController, nc: UINavigationController, updateFilmCount: @escaping UpdateFilmCount) {
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop) { [weak vc] _ in
            vc?.dismiss(animated: true, completion: nil)
        }
        
        vc.title = "Add Film"
        
        let buyFilm: BuyFilmAction = { [weak self, weak vc] film in
            HUD.show(.progress)
            self?.filmController.buyFilm(film)
            updateFilmCount(self?.filmController.currentFilm?.remainingPhotos ?? 0)
            HUD.hide()
            vc?.dismiss(animated: true, completion: nil)
        }
        
        let vm = PurchaseViewModel(buyFilm: buyFilm)
        vc.viewModel = vm
    }
}
