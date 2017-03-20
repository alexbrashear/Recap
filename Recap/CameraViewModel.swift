//
//  CameraViewModel.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 3/6/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

typealias KeepPhotoTapHandler = (_ image: UIImage?) -> Void
typealias SentPostcardsTapHandler = () -> Void

class CameraViewModel: CameraViewModelProtocol {
    var keepPhoto: KeepPhotoTapHandler
    
    var sentPostcardsTapHandler: SentPostcardsTapHandler
    
    init(keepPhoto: @escaping KeepPhotoTapHandler, sentPostcardsTapHandler: @escaping SentPostcardsTapHandler) {
        self.keepPhoto = keepPhoto
        self.sentPostcardsTapHandler = sentPostcardsTapHandler
        
    }
}
