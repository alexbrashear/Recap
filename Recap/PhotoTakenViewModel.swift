//
//  PhotoTakenViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 4/29/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class PhotoTakenViewModel: PhotoTakeViewModelProtocol {
    var sendPhotoAction: SendPhotoAction
    var deletePhotoAction: DeletePhotoAction
    var savePhotoAction: SavePhotoAction
    
    init(sendPhotoAction: @escaping SendPhotoAction, deletePhotoAction: @escaping DeletePhotoAction, savePhotoAction: @escaping SavePhotoAction) {
        self.sendPhotoAction = sendPhotoAction
        self.deletePhotoAction = deletePhotoAction
        self.savePhotoAction = savePhotoAction
    }
}
