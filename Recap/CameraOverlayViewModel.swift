//
//  CameraOverlayViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 4/27/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class CameraOverlayViewModel: CameraOverlayViewModelProtocol {
    var takePhoto: TakePhoto?
    var showSettings: () -> Void
    var sentPostcardsTapHandler: SentPostcardsTapHandler
    var rotateCamera: RotateCamera?
    var sendPhoto: SendPhoto
    var countAction: CountAction
    
    private var userController: UserController
    
    init(userController: UserController, showSettings: @escaping () -> Void, sentPostcardsTapHandler: @escaping SentPostcardsTapHandler, sendPhoto: @escaping SendPhoto, countAction: @escaping CountAction) {
        self.userController = userController
        self.sentPostcardsTapHandler = sentPostcardsTapHandler
        self.showSettings = showSettings
        self.sendPhoto = sendPhoto
        self.countAction = countAction
    }
    
    var count: Int {
        return userController.user?.remainingPhotos ?? 0
    }
}
