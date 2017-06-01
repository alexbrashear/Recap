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
    var showSettings: () -> Void
    var sentPostcardsTapHandler: SentPostcardsTapHandler
    var sendPhoto: SendPhoto
    var initialCount: Int
    
    init(initialCount: Int, sendPhoto: @escaping SendPhoto, sentPostcardsTapHandler: @escaping SentPostcardsTapHandler, showSettings: @escaping () -> Void) {
        self.initialCount = initialCount
        self.sentPostcardsTapHandler = sentPostcardsTapHandler
        self.showSettings = showSettings
        self.sendPhoto = sendPhoto
    }
}
