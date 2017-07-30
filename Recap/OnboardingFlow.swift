//
//  RootFlowCoordinator+Onboarding.swift
//  Recap
//
//  Created by Alex Brashear on 4/19/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import PKHUD
import Apollo

extension RootFlowCoordinator {
    
    // MARK: - Welcome Controller
    
    func configureWelcomeController(_ vc: WelcomeViewController, nc: UINavigationController) {
        nc.setNavigationBarHidden(true, animated: true)
        vc.viewModel = WelcomeViewModel(continueButtonAction: { [weak nc, weak self] in
            guard let nc = nc else { return }
            self?.pushSignupController(onto: nc)
        })
    }
    
    func pushWelomeController(onto nc: UINavigationController) {
        guard let welcomeViewController = R.storyboard.welcome.welcomeViewController() else { fatalError() }
        configureWelcomeController(welcomeViewController, nc: nc)
        nc.pushViewController(welcomeViewController, animated: true)
    }
    
    // MARK: - Enter Address Controller
    
    private func configureEnterAddressController(_ vc: EnterAddressController, nc: UINavigationController, email: String, password: String) {
        let vm = EnterAddressViewModel { [weak self, weak vc, weak nc] address in
            HUD.show(.progress)
            self?.addressProvider.verify(address: address) { [weak self] (address, error) in
                guard let address = address, error == nil else {
                    HUD.hide()
                    vc?.present(error?.alert ?? AddressError.unknownFailure.alert, animated: true, completion: nil); return;
                }
                self?.userController.signupUser(address: address, email: email, password: password) { result in
                    HUD.hide()
                    switch result {
                    case .success:
                        guard let nc = nc else { return }
                        self?.pushDisclaimerController(onto: nc)
                    case let .error(userError):
                        vc?.present(userError.alert, animated: true, completion: nil)
                    }
                }
                
            }
        }
        vc.viewModel = vm
    }
    
    private func pushEnterAddressController(onto nc: UINavigationController, email: String, password: String) {
        guard let vc = R.storyboard.enterAddress.enterAddressController() else { return }
        configureEnterAddressController(vc, nc: nc, email: email, password: password)
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
    
    // MARK: - Login Controller
    
    func pushLoginController(onto nc: UINavigationController) {
        guard let vc = R.storyboard.login.loginViewController() else { return }
        nc.setNavigationBarHidden(true, animated: false)
        
        vc.goToSignUpAction = { [weak nc, weak self] in
            guard let nc = nc else { return }
            let previousIndex = nc.viewControllers.count - 2
            if previousIndex >= 0, nc.viewControllers[previousIndex] is SignUpViewController {
                nc.popViewController(animated: true)
            } else {
                self?.pushSignupController(onto: nc)
            }
        }
        
        vc.loginAction = { [weak self, weak nc, weak vc] email, password in
            HUD.show(.progress)
            self?.userController.loginUser(email: email, password: password) { result in
                HUD.hide()
                switch result {
                case .success:
                    guard let nc = nc else { return }
                    self?.onboardingCoordinator.complete(onboarding: .welcomeFlow)
                    self?.pushCameraViewController(onto: nc)
                case let .error(userError):
                    vc?.present(userError.alert, animated: true, completion: nil)
                }
            }
        }
        nc.pushViewController(vc, animated: true)
    }
    
    // MARK: - Signup Controller
    
    func pushSignupController(onto nc: UINavigationController) {
        guard let vc = R.storyboard.signup.signUpViewController() else { return }
        vc.submitHandler = { [weak self, weak nc] email, password in
            guard let nc = nc else { return }
            self?.pushEnterAddressController(onto: nc, email: email, password: password)
        }
        
        vc.goToLoginHandler = { [weak nc, weak self] in
            guard let nc = nc else { return }
            let previousIndex = nc.viewControllers.count - 2
            if previousIndex >= 0, nc.viewControllers[previousIndex] is LoginViewController {
                nc.popViewController(animated: true)
            } else {
                self?.pushLoginController(onto: nc)
            }
        }
        nc.pushViewController(vc, animated: true)
    }
}
