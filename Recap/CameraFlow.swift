//
//  CameraFlow.swift
//  Recap
//
//  Created by Alex Brashear on 5/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import PKHUD
import Iconic

extension RootFlowCoordinator {
    func pushCameraViewController(onto nc: UINavigationController) {
        guard let cameraViewController = R.storyboard.camera.cameraViewController() else { fatalError() }
        configure(vc: cameraViewController, nc: nc)
        nc.pushViewController(cameraViewController, animated: true)
    }
    
    /// Configures a `CameraViewController`
    ///
    /// - Parameter vc: the view controller to configure
    private func configure(vc: CameraViewController, nc: UINavigationController) {
        let sendPhoto: SendPhoto = { [weak self, weak vc, weak nc] image in
            guard let nc = nc else { return }
            self?.pushFriendsListController(onto: nc, withImage: image)
        }
        
        let sentPostcardsTapHandler: SentPostcardsTapHandler = { [weak self, weak nc] _ in
            guard let nc = nc else { return }
            self?.pushSentPhotosController(onto: nc)
        }
        
        let showSettings: () -> Void = { [weak self, weak vc] in
            guard let userController = self?.userController, let addressProvider = self?.addressProvider, let vc = vc else { return }
            let settingsFlow = SettingsFlowCoordinator(userController: userController, addressProvider: addressProvider)
            settingsFlow.presentSettingsViewController(from: vc)
        }
        
        let countAction: CountAction = { [weak self, weak vc] in
            guard let strongSelf = self, let vc = vc else { return }
            let purchaseFlow = PurchaseFlowCoordinator(userController: strongSelf.userController, paymentsController: strongSelf.paymentsController)
            purchaseFlow.presentPurchaseController(from: vc) { [weak vc, weak self] success in
                if success, let remainingPhotos = self?.userController.user?.remainingPhotos {
                    vc?.overlay.updateCount(to: remainingPhotos)
                }
            }
        }
        
        guard let user = userController.user else { fatalError() }
        let vm = CameraViewModel(initialCount: user.remainingPhotos, sendPhoto: sendPhoto, sentPostcardsTapHandler: sentPostcardsTapHandler, showSettings: showSettings, countAction: countAction)
        vc.viewModel = vm
    }
}

// MARK: - FriendsListController

extension RootFlowCoordinator {
    func pushFriendsListController(onto nc: UINavigationController, withImage image: UIImage) {
        nc.setNavigationBarHidden(false, animated: true)
        let friendsListController = FriendsListController()
        let returnToCamera = { [weak nc] in
            nc?.popViewController(animated: true)
            PKHUD.sharedHUD.contentView = SimpleImageLabelAlert.successfulSend
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 3.0)
        }
        configure(friendsListController, image: image, returnToCamera: returnToCamera)
        nc.pushViewController(friendsListController, animated: true)
    }
    
    private func configure(_ vc: FriendsListController, image: UIImage, returnToCamera: (() -> Void)?) {
        vc.title = "Send To..."
        let button = UIButton()
        let image = FontAwesomeIcon._529Icon.image(ofSize: CGSize(width: 25, height: 25), color: .white)
        button.setImage(image, for: .normal)
        button.on(.touchUpInside) { [weak self, weak vc] _ in
            guard let vc = vc else { return }
            self?.presentEnterAddressController(from: vc)
        }
        let barbutton = UIBarButtonItem(customView: button)
        vc.navigationItem.rightBarButtonItem = barbutton
        
        let sendAction: SendHandler = { [weak self, weak image, weak vc] friends in
            PKHUD.sharedHUD.contentView = SimpleImageLabelAlert.uploading
            PKHUD.sharedHUD.show()
            guard let image = image else { return }
            self?.photoManager.sendImage(image: image, to: friends) { result in
                PKHUD.sharedHUD.hide()
                switch result {
                case .error(let err):
                    vc?.present(err.alert, animated: true, completion: nil)
                case .success:
                    returnToCamera?()
                }
            }
        }
        
        vc.viewModel = FriendsListViewModel(friendsListProvider: friendsListProvider, userController: userController, topBarTapHandler: { [weak self, weak vc] in
            guard let strongSelf = self, let vc = vc else { return }
            let purchaseFlow = PurchaseFlowCoordinator(userController: strongSelf.userController, paymentsController: strongSelf.paymentsController)
            purchaseFlow.presentPurchaseController(from: vc, completion: {_ in})
        }, sendHandler: sendAction)
    }
    
    private func presentEnterAddressController(from presentingViewController: UIViewController) {
        guard let vc = R.storyboard.enterAddress.enterAddressController() else { return }
        configure(vc: vc)
        presentingViewController.present(vc, animated: true, completion: nil)
    }
    
    private func configure(vc: EnterAddressController) {
        let vm = EnterAddressNewFriendViewModel(friendsListProvider: friendsListProvider, backAction: { [weak vc] in
            vc?.dismiss(animated: true, completion: nil)
        })
        vc.viewModel = vm
    }
}
