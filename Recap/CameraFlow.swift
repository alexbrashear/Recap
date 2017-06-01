//
//  CameraFlow.swift
//  Recap
//
//  Created by Alex Brashear on 5/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

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
}
