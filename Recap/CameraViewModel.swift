//
//  CameraViewModel.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 3/6/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

typealias SendPhoto = (_ image: UIImage) -> Void
typealias SentPostcardsTapHandler = () -> Void

class CameraViewModel: CameraViewModelProtocol {
    var sentPostcardsTapHandler: SentPostcardsTapHandler
    var sendPhoto: SendPhoto
    var overlayViewModel: CameraOverlayViewModelProtocol
    
    
    init(userController: UserController, sendPhoto: @escaping SendPhoto, sentPostcardsTapHandler: @escaping SentPostcardsTapHandler, showSettings: @escaping () -> Void, countAction: @escaping CountAction) {
        self.sentPostcardsTapHandler = sentPostcardsTapHandler
        self.sendPhoto = sendPhoto
        
        self.overlayViewModel = CameraOverlayViewModel(userController: userController, showSettings: showSettings, sentPostcardsTapHandler: sentPostcardsTapHandler, sendPhoto: sendPhoto, countAction: countAction)
    }
}
