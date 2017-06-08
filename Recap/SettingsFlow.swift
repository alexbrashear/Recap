//
//  RootFlowCoordinator+Settings.swift
//  Recap
//
//  Created by Alex Brashear on 5/14/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import PKHUD

extension RootFlowCoordinator {
    private func configureSettingsViewController(vc: SettingsViewController, nc: UINavigationController) {
        vc.address = userController.user?.address
        vc.changeAddress = { [weak self, weak nc, weak vc] in
            guard let nc = nc else { return }
            self?.pushEnterAddressController(onto: nc) {
                vc?.address = self?.userController.user?.address
            }
        }
    }
    
    private func configureSettingsNavigationController(nc: UINavigationController, vc: UIViewController) {
        nc.navigationBar.barTintColor = .rcpAzure
        nc.navigationBar.tintColor = .white
        nc.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                NSFontAttributeName: UIFont.openSansLightFont(ofSize: 16)]
        
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop) { [weak vc] _ in
            vc?.dismiss(animated: true, completion: nil)
        }
    }
    
    func presentSettingsViewController(from presentingViewController: UIViewController) {
        guard let vc = R.storyboard.settings.settingsViewController() else { fatalError() }
        let nc = UINavigationController(rootViewController: vc)
        configureSettingsNavigationController(nc: nc, vc: vc)
        configureSettingsViewController(vc: vc, nc: nc)
        presentingViewController.present(nc, animated: true, completion: nil)
    }
    
    // MARK: - Enter Address Controller
    
    private func configureEnterAddressController(_ vc: EnterAddressController, nc: UINavigationController, onSuccess: (() -> Void)?) {
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
                        onSuccess?()
                        nc.popViewController(animated: true)
                    }
                }
            }
        }
        vc.viewModel = vm
    }
    
    private func pushEnterAddressController(onto nc: UINavigationController, onSuccess: (() -> Void)?) {
        guard let vc = R.storyboard.enterAddress.enterAddressController() else { return }
        configureEnterAddressController(vc, nc: nc, onSuccess: onSuccess)
        nc.pushViewController(vc, animated: true)
    }
}
