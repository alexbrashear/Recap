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
        
    }
    
    func configure(vc: AddressListController) {
        
    }
    
    func configure(vc: AddAddressController) {
        
    }
    
    func configure(vc: SentPostcardsViewController) {
        
    }
}
