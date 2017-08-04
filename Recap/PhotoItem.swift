//
//  PhotoItem.swift
//  Recap
//
//  Created by Alex Brashear on 7/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

class PhotoItem: UICollectionViewCell, Reusable {
    
    private var imageView = UIImageView()
    var imageProvider: ImageProvider?
    
    var photo: Photo? {
        didSet {
            guard let photo = photo else { return }
            imageProvider?.fetchImage(forUrl: photo.thumbnails.small) { [weak self] result in
                switch result {
                case let .success(image):
                    self?.imageView.image = image
                case .error:
                    break
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = false
        contentView.addSubview(imageView)
        imageView.constrainToSuperview()
        imageView.backgroundColor = .rcpBlueyGrey
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
