//
//  RootFlowCoordinator+Onboarding.swift
//  Recap
//
//  Created by Alex Brashear on 4/19/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

extension RootFlowCoordinator {
    func configureWelcomeController(_ vc: WelcomeViewController, nc: UINavigationController) {
        nc.setNavigationBarHidden(true, animated: true)
        vc.viewModel = WelcomeViewModel(continueButtonAction: { [weak nc, weak self] in
            guard let nc = nc else { return }
            self?.pushEnterAddressController(onto: nc)
        })
    }
    
    func configureEnterAddressController(_ vc: EnterAddressController) {
        
    }
    
    private func pushEnterAddressController(onto nc: UINavigationController) {
        guard let vc = R.storyboard.enterAddress.enterAddressController() else { return }
        configureEnterAddressController(vc)
        nc.pushViewController(vc, animated: true)
    }
}
