//
//  BaseFlowCoordinator.swift
//  Recap
//
//  Created by Alex Brashear on 9/30/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class BaseFlowCoordinator {
    func configureNavigationController(nc: UINavigationController) {
        nc.navigationBar.barTintColor = .rcpAzure
        nc.navigationBar.tintColor = .white
        nc.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                NSFontAttributeName: UIFont.openSansSemiBoldFont(ofSize: 20)]
    }
}
