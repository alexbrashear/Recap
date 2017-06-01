//
//  CameraOverlayViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 4/27/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class CameraOverlayViewModel: CameraOverlayViewModelProtocol {
    var takePhoto: TakePhoto
    var showSettings: () -> Void
    var sentPostcardsTapHandler: SentPostcardsTapHandler
    var rotateCamera: RotateCamera
    var sendPhoto: SendPhoto
    var initialCount: Int
    
    init(initialCount: Int, takePhoto: @escaping TakePhoto, showSettings: @escaping () -> Void, sentPostcardsTapHandler: @escaping SentPostcardsTapHandler, rotateCamera: @escaping RotateCamera, sendPhoto: @escaping SendPhoto) {
        self.initialCount = initialCount
        self.takePhoto = takePhoto
        self.rotateCamera = rotateCamera
        self.sentPostcardsTapHandler = sentPostcardsTapHandler
        self.showSettings = showSettings
        self.sendPhoto = sendPhoto
    }
}
