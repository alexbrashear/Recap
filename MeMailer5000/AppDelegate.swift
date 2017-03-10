//
//  AppDelegate.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 1/28/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let databaseController = DatabaseController.sharedInstance
    private let addressListProvider = AddressListProvider()
    
    private var rootFlowCoordinator: RootFlowCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        rootFlowCoordinator = RootFlowCoordinator(addressListProvider: addressListProvider)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = rootFlowCoordinator?.rootViewController
        rootFlowCoordinator?.load()
        window?.makeKeyAndVisible()
        
        return true
    }

    }
}
