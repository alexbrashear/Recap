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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let databaseController = DatabaseController.sharedInstance
    
    private var rootFlowCoordinator: RootFlowCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let credentialProvider = AWSCognitoCredentialsProvider(regionType: .USEast1, identityPoolId: AWSCredentials.identityPoolId)
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider: credentialProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let apolloWrapper = ApolloWrapper()
        rootFlowCoordinator = RootFlowCoordinator(userController: UserController(graphql: apolloWrapper),
                                                  filmController: FilmController(graphql: apolloWrapper))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = rootFlowCoordinator?.rootViewController
        rootFlowCoordinator?.load()
        window?.makeKeyAndVisible()
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 75
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
}
