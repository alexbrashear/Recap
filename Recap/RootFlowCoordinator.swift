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
    
    init(userController: UserController) {
        navigationController = UINavigationController()
        self.userController = userController
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
    
    /// Configures a `CameraViewController`
    ///
    /// - Parameter vc: the view controller to configure
    func configure(vc: CameraViewController, nc: UINavigationController) {
        let sendPhoto: SendPhoto = { [weak self, weak vc] image in
            guard let address = self?.userController.user?.address else { return }
            vc?.presentAlert(.uploadingRecap)
            self?.postcardSender.send(image: image, to: address) { result in
                let (_, error) = result
                DispatchQueue.main.async {
                    if let error = error {
                        vc?.returnToCamera(with: .errorSending(error))
                    } else {
                        vc?.returnToCamera(with: .successfulSend)
                    }
                }
            }
        }
        let sentPostcardsTapHandler: SentPostcardsTapHandler = { _ in
            
        }
        
        nc.setNavigationBarHidden(true, animated: true)
        let vm = CameraViewModel(sendPhoto: sendPhoto, sentPostcardsTapHandler: sentPostcardsTapHandler)
        vc.viewModel = vm
    }
    
    func pushCameraViewController(onto nc: UINavigationController) {
        guard let cameraViewController = R.storyboard.camera.cameraViewController() else { fatalError() }
        configure(vc: cameraViewController, nc: nc)
        nc.pushViewController(cameraViewController, animated: true)
    }
}
