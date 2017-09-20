//
//  AppDelegate.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 1/28/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import AWSS3
import IQKeyboardManagerSwift
import Apollo
import FacebookCore
import FacebookLogin
import Iconic

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let persistanceManager = PersistanceManager()
    
    private var rootFlowCoordinator: RootFlowCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        FontAwesomeIcon.register()
        setupAWS()
        
        let token = persistanceManager.token
        let userController = UserController(graphql: ApolloWrapper(token: token), persistanceManager: persistanceManager)
        if token != nil {
            userController.loadUser()
        }
        
        rootFlowCoordinator = RootFlowCoordinator(userController: userController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = rootFlowCoordinator?.rootViewController
        rootFlowCoordinator?.load()
        window?.makeKeyAndVisible()
        
        setupMovingKeyboard()
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        SDKApplicationDelegate.shared.application(app, open: url, options: options)
        return true
    }
}

extension AppDelegate {
    func setupAWS() {
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: AWSCredentials.identityPoolId)
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider: credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func setupMovingKeyboard() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 75
    }
}
