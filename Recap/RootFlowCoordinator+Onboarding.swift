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
        vc.viewModel = WelcomeViewModel(continueButtonAction: { [weak nc] in
            print("pressed")
        })
    }
}
