//
//  RootFlowCoordinator+Settings.swift
//  Recap
//
//  Created by Alex Brashear on 5/14/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import PKHUD
import FacebookCore

class SettingsFlowCoordinator: BaseFlowCoordinator {
    
    private var key = "PurhcaseFlowCoordinator"

    let userController: UserController
    let addressProvider: AddressProvider
    
    init(userController: UserController, addressProvider: AddressProvider) {
        self.userController = userController
        self.addressProvider = addressProvider
    }
    
    override func configureNavigationController(nc: UINavigationController) {
        super.configureNavigationController(nc: nc)
    }
    
    func presentSettingsViewController(from presentingViewController: UIViewController) {
        guard let vc = R.storyboard.settings.settingsViewController() else { fatalError() }
        vc.setAssociatedObject(self, forKey: &key, policy: .retain)

        let nc = UINavigationController(rootViewController: vc)
        configureNavigationController(nc: nc)
        configureSettingsViewController(vc: vc, nc: nc)
        presentingViewController.present(nc, animated: true, completion: nil)
    }
    
    private func configureSettingsViewController(vc: SettingsViewController, nc: UINavigationController) {
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop) { [weak vc] _ in
            vc?.dismiss(animated: true, completion: nil)
        }
        vc.viewModel = SettingsViewModel()
        //        vc.address = userController.user?.address
        //        vc.changeAddress = { [weak self, weak nc, weak vc] in
        //            guard let nc = nc else { return }
        //            self?.pushEnterAddressController(onto: nc) {
        //                vc?.address = self?.userController.user?.address
        //            }
        //        }
        
        //        vc.isLoggedInToFacebook = AccessToken.current != nil
        //
        //        vc.connectSocial = { [weak self, weak vc] in
        //            HUD.show(.progress)
        //            self?.userController.loginWithSocial { result in
        //                HUD.hide()
        //                switch result {
        //                case .success:
        //                    vc?.isLoggedInToFacebook = true
        //                case let .error(socialError):
        //                    vc?.present(socialError.alert, animated: true, completion: nil)
        //                }
        //            }
        //        }
    }
    
    // MARK: - Enter Address Controller
    
    private func configureEnterAddressController(_ vc: EnterAddressController, nc: UINavigationController, onSuccess: (() -> Void)?) {
        let vm = EnterAddressViewModel { [weak self, weak vc, weak nc] newAddress in
            HUD.show(.progress)
            self?.addressProvider.verify(address: newAddress) { [weak self] (verifiedAddress, error) in
                guard let verifiedAddress = verifiedAddress, error == nil else {
                    HUD.hide()
                    vc?.present(error?.alert ?? UserError.updateAddressFailed.alert, animated: true, completion: nil); return
                }
                self?.userController.updateAddress(newAddress: verifiedAddress) { result in
                    HUD.hide()
                    guard let nc = nc else { return }
                    onSuccess?()
                    nc.popViewController(animated: true)
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
