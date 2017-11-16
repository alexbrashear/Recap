//
//  Purchase.swift
//  Recap
//
//  Created by Alex Brashear on 5/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import PKHUD
import Braintree
import BraintreeDropIn

typealias PurchaseCompletion = (_ purchaseCompleted: Bool) -> Void

class PurchaseFlowCoordinator: BaseFlowCoordinator {
    
    private var key = "PurhcaseFlowCoordinator"
    
    let userController: UserController
    let paymentsController: PaymentsController
    
    init(userController: UserController, paymentsController: PaymentsController) {
        self.userController = userController
        self.paymentsController = paymentsController
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
        
        let buyFilm: BuyFilmAction = { [weak self, weak vc] packs, capacity in
            HUD.show(.progress)
            self?.paymentsController.buyFilm(packs: packs, capacity: capacity) { result in
                HUD.hide()
                switch result {
                case .success:
                    vc?.dismiss(animated: true, completion: { completion(true) })
                case let .error(err):
                    vc?.present(err.alert, animated: true, completion: nil)
                }
            }
        }
        
        let paymentInformation = { [weak self, weak vc] in
            HUD.show(.progress)
            self?.paymentsController.paymentsDropInController { dropInController in
                DispatchQueue.main.async {
                    HUD.hide()
                    guard let dropInController = dropInController else { return }
                    vc?.present(dropInController, animated: true, completion: nil)
                }
            }
        }
        
        let vm = PurchaseViewModel(buyFilm: buyFilm, paymentInformation: paymentInformation)
        vc.viewModel = vm
    }
}
