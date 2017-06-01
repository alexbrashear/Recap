//
//  Purchase.swift
//  Recap
//
//  Created by Alex Brashear on 5/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

extension RootFlowCoordinator {
    func presentPurchaseController(from presentingViewController: UIViewController) {
        guard let vc = R.storyboard.purchase.purchaseViewController() else { return }
        let nc = UINavigationController(rootViewController: vc)
        configureNavigationController(nc: nc)
        configurePurchaseViewController(vc: vc, nc: nc)
        presentingViewController.present(nc, animated: true, completion: nil)
    }
    
    private func configurePurchaseViewController(vc: PurchaseViewController, nc: UINavigationController) {
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop) { [weak vc] _ in
            vc?.dismiss(animated: true, completion: nil)
        }
    }
}
