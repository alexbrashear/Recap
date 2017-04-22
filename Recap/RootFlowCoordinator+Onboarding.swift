//
//  RootFlowCoordinator+Onboarding.swift
//  Recap
//
//  Created by Alex Brashear on 4/19/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import PKHUD

extension RootFlowCoordinator {
    func configureWelcomeController(_ vc: WelcomeViewController, nc: UINavigationController) {
        nc.setNavigationBarHidden(true, animated: true)
        vc.viewModel = WelcomeViewModel(continueButtonAction: { [weak nc, weak self] in
            guard let nc = nc else { return }
            self?.pushEnterAddressController(onto: nc)
        })
    }
    
    func configureEnterAddressController(_ vc: EnterAddressController) {
        let vm = EnterAddressViewModel { [weak self, weak vc] address in
            HUD.show(.progress)
            self?.addressProvider.verify(address: address) { [weak self] (address, error) in
                DispatchQueue.main.async {
                    HUD.hide()
                    guard let vc = vc else { return }
                    if let error = error {
                        let alert = UIAlertController.okAlert(title: error.localizedTitle, message: error.localizedDescription)
                        vc.present(alert, animated: true, completion: nil)
                    } else {
                        self?.pushCameraViewController()
                    }
                }
            }
        }
        vc.viewModel = vm
    }
    
    private func pushEnterAddressController(onto nc: UINavigationController) {
        guard let vc = R.storyboard.enterAddress.enterAddressController() else { return }
        configureEnterAddressController(vc)
        nc.pushViewController(vc, animated: true)
    }
}
