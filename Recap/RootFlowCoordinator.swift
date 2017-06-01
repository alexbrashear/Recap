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
    
    /// Configures a `CameraViewController`
    ///
    /// - Parameter vc: the view controller to configure
    func configure(vc: CameraViewController, nc: UINavigationController) {
        let sendPhoto: SendPhoto = { [weak self, weak vc] image in
            guard self?.filmController.canTakePhoto() ?? false else {
                vc?.presentAlert(.errorSending(PhotoError.noFilmError))
                return
            }
            guard let address = self?.userController.user?.address else { return }
            vc?.presentAlert(.uploadingRecap)
            self?.postcardSender.send(image: image, to: address) { result in
                let (photo, error) = result
                DispatchQueue.main.async {
                    switch (photo, error) {
                    case let (_, .some(error)):
                        vc?.returnToCamera(with: .errorSending(error))
                    case (.none, .none):
                        vc?.returnToCamera(with: .errorSending(PhotoError.unknownFailure))
                    case let (.some(photo), .none):
                        let remainingPhotos = self?.filmController.useFilmSlot(photo) ?? 0
                        vc?.returnToCamera(with: .successfulSend)
                        vc?.overlay.updateCount(to: remainingPhotos)
                    }
                }
            }
        }
        let sentPostcardsTapHandler: SentPostcardsTapHandler = { [weak self, weak nc] _ in
            guard let nc = nc else { return }
            self?.pushSentPhotosController(onto: nc)
        }
        
        let showSettings: () -> Void = { [weak self, weak vc] in
            guard let vc = vc else  { return }
            self?.presentSettingsViewController(from: vc)
        }
        
        let countAction: CountAction = { [weak self, weak vc] in
            guard let vc = vc else { return }
            self?.presentPurchaseController(from: vc)
        }
        
        let vm = CameraViewModel(initialCount: filmController.currentFilm?.remainingPhotos ?? 0, sendPhoto: sendPhoto, sentPostcardsTapHandler: sentPostcardsTapHandler, showSettings: showSettings, countAction: countAction)
        vc.viewModel = vm
    }
    
    func pushCameraViewController(onto nc: UINavigationController) {
        guard let cameraViewController = R.storyboard.camera.cameraViewController() else { fatalError() }
        configure(vc: cameraViewController, nc: nc)
        nc.pushViewController(cameraViewController, animated: true)
    }
    
    func configureNavigationController(nc: UINavigationController) {
        nc.navigationBar.barTintColor = .rcpAzure
        nc.navigationBar.tintColor = .white
        nc.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                NSFontAttributeName: UIFont.openSansSemiBoldFont(ofSize: 20)]
    }
}
