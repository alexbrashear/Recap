//
//  RootFlowCoordinator.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 3/6/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class RootFlowCoordinator {
    
    /// The root navigation controller
    var navigationController: UINavigationController
    /// the address provider
    let addressProvider = AddressProvider()
    /// the coordinator to handle onboarding
    let onboardingCoordinator = OnboardingCoordinator()
    /// helper type for sending photos
    let postcardSender = PostcardSender()
    
    let userController: UserController
    let filmController: FilmController
    
    init(userController: UserController, filmController: FilmController) {
        navigationController = UINavigationController()
        self.userController = userController
        self.filmController = filmController
    }
    
    /// the root view controller to be used only by the app delegate
    var rootViewController: UIViewController {
        return navigationController
    }
    
    /// loads the initial view controller
    func load() {
        if onboardingCoordinator.shouldShow(onboarding: .welcomeFlow) {
            pushWelomeController(onto: navigationController)
        } else {
            guard userController.user != nil else { fatalError() }
            pushCameraViewController(onto: navigationController)
        }
    }
    
    func configureNavigationController(nc: UINavigationController) {
        nc.navigationBar.barTintColor = .rcpAzure
        nc.navigationBar.tintColor = .white
        nc.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                NSFontAttributeName: UIFont.openSansSemiBoldFont(ofSize: 20)]
    }
}
