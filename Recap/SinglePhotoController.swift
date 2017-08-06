//
//  SinglePhotoController.swift
//  Recap
//
//  Created by Alex Brashear on 8/5/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

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
    }
}
