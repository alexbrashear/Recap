//
//  PhotoTakenViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 4/29/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class PhotoTakenViewModel: PhotoTakeViewModelProtocol {
    var sendPhoto: SendPhoto
    var deletePhotoAction: DeletePhotoAction
    var savePhotoAction: SavePhotoAction
    
    init(sendPhoto: @escaping SendPhoto, deletePhotoAction: @escaping DeletePhotoAction, savePhotoAction: @escaping SavePhotoAction) {
        self.sendPhoto = sendPhoto
        self.deletePhotoAction = deletePhotoAction
        self.savePhotoAction = savePhotoAction
    }
}
