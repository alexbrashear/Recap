//
//  SinglePhotoController.swift
//  Recap
//
//  Created by Alex Brashear on 8/5/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable
import PKHUD

class SinglePhotoController: UIViewController {
    
    let singlePhotoView = SinglePhotoView.loadFromNib()
    let imageProvider: ImageProvider
    let photo: Photo
    
    init(imageProvider: ImageProvider, photo: Photo) {
        self.imageProvider = imageProvider
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(singlePhotoView)
//        singlePhotoView.constrainToSuperview()
        singlePhotoView.translatesAutoresizingMaskIntoConstraints = false
        singlePhotoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        singlePhotoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        singlePhotoView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        singlePhotoView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        singlePhotoView.imageProvider = imageProvider
        singlePhotoView.photo = photo
        singlePhotoView.savePhoto = { [weak self] image in
            self?.savePhoto(image: image)
        }
    }
    
    func savePhoto(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image.fixOrientation(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        PKHUD.sharedHUD.contentView = UIView()
        PKHUD.sharedHUD.show()
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            PKHUD.sharedHUD.hide()
            let alert = UIAlertController.okAlert(title: "Sorry we couldn't save your photo", message: "Check your settings to make sure you've given Recap access to your photo library.")
            present(alert, animated: true, completion: nil)
        } else {
            PKHUD.sharedHUD.contentView = SimpleImageLabelAlert.successfulSave
            PKHUD.sharedHUD.show()
            PKHUD.sharedHUD.hide(afterDelay: 3.0)
        }
    }
}
