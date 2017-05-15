//
//  RootFlowCoordinator+Settings.swift
//  Recap
//
//  Created by Alex Brashear on 5/14/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

extension RootFlowCoordinator {
    private func configureSettingsViewController(vc: SettingsViewController) {
        
    }
    
    private func configureSettingsNavigationController(nc: UINavigationController) {
        nc.navigationBar.barTintColor = .rcpClearBlueTwo
        nc.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                NSFontAttributeName: UIFont.openSansLightFont(ofSize: 16)]
    }
    
    func presentSettingsViewController(from presentingViewController: UIViewController) {
        guard let vc = R.storyboard.settings.settingsViewController() else { fatalError() }
        let nc = UINavigationController(rootViewController: vc)
        configureSettingsNavigationController(nc: nc)
        configureSettingsViewController(vc: vc)
        presentingViewController.present(nc, animated: true, completion: nil)
    }
}
