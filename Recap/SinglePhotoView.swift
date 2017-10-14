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
            imageProvider?.fetchImage(forUrl: photo.imageURL) { [weak self] result in
                switch result {
                case let .success(image):
                    self?.imageView.image = image
                case .error:
                    break
                }
            }
            
            deliveryCountdown.text = ""
            sentTo.text = photo.displayableRecipients
        }
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var sentTo: UILabel!
    @IBOutlet var deliveryCountdown: UILabel!
    @IBOutlet var save: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
    }
}

fileprivate extension Photo {
    var displayableRecipients: String {
        var str = ""
        for each in recipients {
            if str == "" {
                str = each.name
            } else {
                str = "\(str), \(each.name)"
            }
        }
        return str
    }
}
