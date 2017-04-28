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
    /// the address list provider
    let addressListProvider: AddressListProviderProtocol
    /// the coordinator to handle onboarding
    let onboardingCoordinator = OnboardingCoordinator()
    
    let userController: UserController
    
    init(addressListProvider: AddressListProviderProtocol, userController: UserController) {
        navigationController = UINavigationController()
        self.addressListProvider = addressListProvider
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
        let keepPhoto: KeepPhotoTapHandler = { [weak self] image in
            self?.pushAddressList(image: image)
        }
        let sentPostcardsTapHandler: SentPostcardsTapHandler = { [weak self] in
            self?.pushSentPostcards()
        }
        
        nc.setNavigationBarHidden(true, animated: true)
        let vm = CameraViewModel(keepPhoto: keepPhoto, sentPostcardsTapHandler: sentPostcardsTapHandler)
        vc.viewModel = vm
    }
    
    func pushCameraViewController(onto nc: UINavigationController) {
        guard let cameraViewController = R.storyboard.camera.cameraViewController() else { fatalError() }
        configure(vc: cameraViewController, nc: nc)
        nc.pushViewController(cameraViewController, animated: true)
    }
    
    /// Pushes the addressListController on to the stack
    ///
    /// - Parameter image: the image taken
    func pushAddressList(image: UIImage?) {
        guard let addressList = R.storyboard.addressList.addressListController() else { return }
        configure(vc: addressList, image: image)
        navigationController.pushViewController(addressList, animated: true)
    }
    
    func configure(vc: AddressListController, image: UIImage?) {
        let addAddress = UIBarButtonItem(barButtonSystemItem: .add) { [weak self] _ in
            self?.presentAddAddress()
        }
        vc.navigationItem.rightBarButtonItem = addAddress
        
        vc.image = image
        vc.viewModel = AddressListViewModel(addresses: addressListProvider.loadAddresses(), addressListProvider: addressListProvider) { [weak self] in
            _ = self?.navigationController.popToRootViewController(animated: false)
            self?.pushSentPostcards()
        }
    }
    
    func presentAddAddress() {
        guard let addAddressController = R.storyboard.addAddress.addAddressController() else { return }
        let nc = UINavigationController(rootViewController: addAddressController)
        navigationController.present(nc, animated: true, completion: nil)
    }
    
    func pushSentPostcards() {
        guard let sentPostcards = R.storyboard.postcards.sentPostcardsViewController() else { return }
        configure(vc: sentPostcards)
        navigationController.pushViewController(sentPostcards, animated: true)
    }
    
    func configure(vc: SentPostcardsViewController) {
        
    }
}
