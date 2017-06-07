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
    
    // MARK: - Welcome Controller
    
    func configureWelcomeController(_ vc: WelcomeViewController, nc: UINavigationController) {
        nc.setNavigationBarHidden(true, animated: true)
        vc.viewModel = WelcomeViewModel(continueButtonAction: { [weak nc, weak self] in
            guard let nc = nc else { return }
            self?.pushEnterAddressController(onto: nc)
        })
    }
    
    func pushWelomeController(onto nc: UINavigationController) {
        guard let welcomeViewController = R.storyboard.welcome.welcomeViewController() else { fatalError() }
        configureWelcomeController(welcomeViewController, nc: nc)
        nc.pushViewController(welcomeViewController, animated: true)
    }
    
    // MARK: - Enter Address Controller
    
    func configureEnterAddressController(_ vc: EnterAddressController, nc: UINavigationController) {
        let vm = EnterAddressViewModel { [weak self, weak vc, weak nc] address in
            HUD.show(.progress)
            self?.addressProvider.verify(address: address) { [weak self] (address, error) in
                DispatchQueue.main.async {
                    HUD.hide()
                    guard let vc = vc, let nc = nc else { return }
                    if let error = error {
                        let alert = UIAlertController.okAlert(title: error.localizedTitle, message: error.localizedDescription)
                        vc.present(alert, animated: true, completion: nil)
                    } else {
                        guard let address = address else { return }
                        self?.userController.setNewUser(address: address)
                        self?.pushDisclaimerController(onto: nc)
                    }
                }
            }
        }
        vc.viewModel = vm
    }
    
    private func pushEnterAddressController(onto nc: UINavigationController) {
        guard let vc = R.storyboard.enterAddress.enterAddressController() else { return }
        configureEnterAddressController(vc, nc: nc)
        nc.pushViewController(vc, animated: true)
    }
    
    // MARK: - Disclaimer Controller
    
    private func configureDisclaimerController(_ vc: DisclaimerController, nc: UINavigationController) {
        let vm = DisclaimerViewModel(disclaimerAction: { [weak self, weak nc] in
            guard let nc = nc else { return }
            self?.onboardingCoordinator.complete(onboarding: .welcomeFlow)
            self?.pushCameraViewController(onto: nc)
        })
        vc.viewModel = vm
    }
    
    private func pushDisclaimerController(onto nc: UINavigationController) {
        guard let vc = R.storyboard.disclaimer.disclaimerController() else { return }
        configureDisclaimerController(vc, nc: nc)
        nc.pushViewController(vc, animated: true)
    }
}
