//
//  RootFlowCoordinator+Settings.swift
//  Recap
//
//  Created by Alex Brashear on 5/14/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import PKHUD
import MessageUI

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
        let vc = SettingsViewController()
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
        let enterAddress: () -> Void = { [weak self, weak nc] in
            guard let nc = nc else { return }
            self?.pushEnterAddressController(onto: nc)
        }
        
        let feedbackAction: () -> Void = { [weak self, weak vc] in
            guard let vc = vc else { return }
            self?.presentMailComposeViewController(from: vc)
        }
        
        let connectFacebook: () -> Void = { [weak self, weak vc] in
            HUD.show(.progress)
            self?.userController.loginWithSocial { result in
                HUD.hide()
                switch result {
                case .success: break
                case let .error(socialError):
                    vc?.present(socialError.alert, animated: true, completion: nil)
                }
            }
        }
        
        vc.viewModel = SettingsViewModel(userController: userController, enterAddress: enterAddress, feedbackAction: feedbackAction, connectFacebook: connectFacebook)
    }
    
    // MARK: - Enter Address Controller
    
    private func configureEnterAddressController(_ vc: EnterAddressController, nc: UINavigationController) {
        let backAction: (() -> Void)? = { [weak nc] in
            nc?.popViewController(animated: true)
            nc?.setNavigationBarHidden(false, animated: true)
        }
        
        let nextAction: NextAction = { [weak self, weak vc, weak nc] newAddress in
            HUD.show(.progress)
            self?.addressProvider.verify(address: newAddress) { [weak self] (verifiedAddress, error) in
                guard let verifiedAddress = verifiedAddress, error == nil else {
                    HUD.hide()
                    vc?.present(error?.alert ?? UserError.updateAddressFailed.alert, animated: true, completion: nil); return
                }
                self?.userController.updateAddress(newAddress: verifiedAddress) { result in
                    HUD.hide()
                    backAction?()
                }
            }
        }
        
        vc.viewModel = EnterAddressSignupViewModel(backAction: backAction!, nextAction: nextAction)
    }
    
    private func pushEnterAddressController(onto nc: UINavigationController) {
        guard let vc = R.storyboard.enterAddress.enterAddressController() else { return }
        configureEnterAddressController(vc, nc: nc)
        nc.setNavigationBarHidden(true, animated: true)
        nc.pushViewController(vc, animated: true)
    }
}

extension SettingsFlowCoordinator: MFMailComposeViewControllerDelegate {
    fileprivate func presentMailComposeViewController(from vc: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            configure(vc: mailComposeVC)
            vc.present(mailComposeVC, animated: true, completion: nil)
        } else {
            let alert = createSendMailErrorAlert()
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func configure(vc: MFMailComposeViewController) {
        vc.mailComposeDelegate = self
        vc.setToRecipients(["help@recap-app.com"])
        vc.setSubject("I've got feedback!")
        vc.setMessageBody("", isHTML: false)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func createSendMailErrorAlert() -> UIAlertController {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Access Mail", message: "Unfortunately we could not access your mail client but we saved help@recap-app.com to your clipboard, shoot us an email! Thanks!", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        UIPasteboard.general.string = "help@recap-app.com"
        return sendMailErrorAlert
    }
}
