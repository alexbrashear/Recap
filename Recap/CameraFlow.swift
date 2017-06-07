//
//  CameraFlow.swift
//  Recap
//
//  Created by Alex Brashear on 5/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import PKHUD

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
        let sendPhoto: SendPhoto = { [weak self, weak vc] image in
            guard self?.filmController.canTakePhoto() ?? false else {
                return
            }
            guard let address = self?.userController.user?.address else { return }
            PKHUD.sharedHUD.contentView = SimpleImageLabelAlert.uploading
            PKHUD.sharedHUD.show()
            self?.postcardSender.send(image: image, to: address) { result in
                let (photo, error) = result
                DispatchQueue.main.async {
                    PKHUD.sharedHUD.hide()
                    switch (photo, error) {
                    case let (_, .some(error)):
                        let alert = UIAlertController.okAlert(title: error.localizedTitle, message: error.localizedDescription)
                        vc?.present(alert, animated: true, completion: nil)
                    case (.none, .none):
                        let alert = UIAlertController.okAlert(title: "Sorry we couldn't send your recap", message: "Please try again or save the pic with the button in the bottom left.")
                        vc?.present(alert, animated: true, completion: nil)
                    case let (.some(photo), .none):
                        let remainingPhotos = self?.filmController.useFilmSlot(photo) ?? 0
                        vc?.returnToCamera()
                        vc?.overlay.updateCount(to: remainingPhotos)
                        PKHUD.sharedHUD.contentView = SimpleImageLabelAlert.successfulSend
                        PKHUD.sharedHUD.show()
                        PKHUD.sharedHUD.hide(afterDelay: 3.0)
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
            self?.presentPurchaseController(from: vc) { [weak vc] newCount in
                vc?.overlay.updateCount(to: newCount)
            }
        }
        
        let vm = CameraViewModel(initialCount: filmController.currentFilm?.remainingPhotos ?? 0, sendPhoto: sendPhoto, sentPostcardsTapHandler: sentPostcardsTapHandler, showSettings: showSettings, countAction: countAction)
        vc.viewModel = vm
    }
}
