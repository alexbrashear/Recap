//
//  SinglePhotoView.swift
//  Recap
//
//  Created by Alex Brashear on 8/5/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

class SinglePhotoView: UIView, NibLoadable {
    
    var imageProvider: ImageProvider?
    var photo: Photo? {
        didSet {
            guard let photo = photo else { return }
//            imageProvider?.fetchImage(forUrl: photo.thumbnails.medium) { [weak self] result in
//                switch result {
//                case let .success(image):
//                    self?.imageView.image = image
//                case .error:
//                    break
//                }
//            }
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var sentTo: UILabel!
    @IBOutlet var deliveryCountdown: UILabel!
    @IBOutlet var save: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
    }
}
