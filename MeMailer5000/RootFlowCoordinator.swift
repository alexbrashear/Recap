//
//  RootFlowCoordinator.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 3/6/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class RootFlowCoordinator {
    
    var navigationController: UINavigationController
    
    init() {
        navigationController = UINavigationController()
    }
    
    var rootViewController: UIViewController {
        return navigationController
    }
    
    func load() {
        guard let cameraViewController = R.storyboard.camera.cameraViewController() else { fatalError() }
        configure(vc: cameraViewController)
        navigationController.pushViewController(cameraViewController, animated: true)
    }
    
    func configure(vc: CameraViewController) {
        let keepPhoto: KeepPhotoTapHandler = { [weak self] image in
            self?.pushAddressList(image: image)
        }
        let sentPostcardsTapHandler: SentPostcardsTapHandler = { [weak self] in
            self?.pushSentPostcards()
        }
        let vm = CameraViewModel(keepPhoto: keepPhoto, sentPostcardsTapHandler: sentPostcardsTapHandler)
        vc.viewModel = vm
    }
    
    func pushAddressList(image: UIImage?) {
        guard let addressList = R.storyboard.addressList.addressListController() else { return }
        configure(vc: addressList, image: image)
        navigationController.pushViewController(addressList, animated: true)
    }
    
    func configure(vc: AddressListController, image: UIImage?) {
        vc.image = image
    }
    
    func configure(vc: AddAddressController) {
        
    }
    
    func pushSentPostcards() {
        guard let sentPostcards = R.storyboard.postcards.sentPostcardsViewController() else { return }
        configure(vc: sentPostcards)
        navigationController.pushViewController(sentPostcards, animated: true)
    }
    
    func configure(vc: SentPostcardsViewController) {
        
    }
}
