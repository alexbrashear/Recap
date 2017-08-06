//
//  RootFlowCoordinator+SentPhotos.swift
//  Recap
//
//  Created by Alex Brashear on 5/18/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

extension RootFlowCoordinator {
    func pushSentPhotosController(onto nc: UINavigationController) {
        let vc = SentPhotosController()
        vc.title = "Sent Recaps"
        configureUsedFilmNavBar(nc: nc)
        configureSentPhotosController(vc: vc, nc: nc)
        nc.pushViewController(vc, animated: true)
        nc.setNavigationBarHidden(false, animated: true)
    }
    
    private func configureUsedFilmNavBar(nc: UINavigationController) {
        nc.navigationBar.barTintColor = .rcpAzure
        nc.navigationBar.tintColor = .white
        nc.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                NSFontAttributeName: UIFont.openSansSemiBoldFont(ofSize: 20)]
        
    }
    
    private func configureSentPhotosController(vc: SentPhotosController, nc: UINavigationController) {
        vc.imageProvider = imageProvider
        userController.getFilm { result in
            switch result {
            case let .success(photos):
                vc.photos = photos
            case let .error(photoError):
                vc.present(photoError.alert, animated: true, completion: nil)
            }
        }
        
        vc.didTapPhoto = { [weak self, weak nc] photo in
            guard let imageProvider = self?.imageProvider else { return }
            let vc = SinglePhotoController(imageProvider: imageProvider, photo: photo)
            nc?.pushViewController(vc, animated: true)
        }
    }
}
