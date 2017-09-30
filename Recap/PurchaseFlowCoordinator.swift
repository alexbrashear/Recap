//
//  Purchase.swift
//  Recap
//
//  Created by Alex Brashear on 5/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import PKHUD

typealias PurchaseCompletion = (_ purchaseCompleted: Bool) -> Void

class PurchaseFlowCoordinator: BaseFlowCoordinator {
    
    private var key = "PurhcaseFlowCoordinator"
    
    let userController: UserController
    
    init(userController: UserController) {
        self.userController = userController
    }
    
    func presentPurchaseController(from presentingViewController: UIViewController, completion: @escaping PurchaseCompletion) {
        guard let vc = R.storyboard.purchase.purchaseViewController() else { return }
        vc.setAssociatedObject(self, forKey: &key, policy: .retain)
        let nc = UINavigationController(rootViewController: vc)
        configureNavigationController(nc: nc)
        configurePurchaseViewController(vc: vc, nc: nc, completion: completion)
        presentingViewController.present(nc, animated: true, completion: nil)
    }
    
    private func configurePurchaseViewController(vc: PurchaseViewController, nc: UINavigationController, completion: @escaping PurchaseCompletion) {
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop) { [weak vc] _ in
            vc?.dismiss(animated: true, completion: { completion(false) })
        }
        
        vc.title = "Add Film"
        
        let buyFilm: BuyFilmAction = { [weak self, weak vc] capacity in
            HUD.show(.progress)
            self?.userController.buyFilm(capacity: capacity) { result in
                HUD.hide()
                switch result {
                case let .success:
                    vc?.dismiss(animated: true, completion: { completion(true) })
                case let .error(userError):
                    vc?.present(userError.alert, animated: true, completion: nil)
                }
            }
        }
        
        let vm = PurchaseViewModel(buyFilm: buyFilm)
        vc.viewModel = vm
    }
}
