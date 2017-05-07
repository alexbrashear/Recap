//
//  PhotoTakenView.swift
//  Recap
//
//  Created by Alex Brashear on 4/28/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

typealias DeletePhotoAction = () -> Void
typealias SavePhotoAction = () -> Void

protocol PhotoTakeViewModelProtocol: class  {
    var sendPhoto: SendPhoto { get }
    var deletePhotoAction: DeletePhotoAction { get }
    var savePhotoAction: SavePhotoAction { get }
}

class PhotoTakenView: UIView {
    
    private let imageView = UIImageView()
    private let back = UIButton()
    private let send = UIButton()
    private let save = UIButton()
    
    var viewModel: PhotoTakeViewModelProtocol? {
        didSet {
            back.on(.touchUpInside) { [unowned self] _ in
                self.viewModel?.deletePhotoAction()
            }
            send.on(.touchUpInside) { [unowned self] _ in
                guard let image = self.imageView.image else { return }
                self.viewModel?.sendPhoto(image)
            }
            save.on(.touchUpInside) { [weak self] _ in
                self?.viewModel?.savePhotoAction()
            }
        }
    }
    
    init(frame: CGRect, image: UIImage) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(back)
        addSubview(send)
        addSubview(save)
        
        imageView.constrainToSuperview()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image

        
        send.translatesAutoresizingMaskIntoConstraints = false
        send.setImage(UIImage(named: "iconSend"), for: .normal)
        addConstraint(NSLayoutConstraint(item: send, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 0.96, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: send, attribute: .width, relatedBy: .equal, toItem: send, attribute: .height, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: send, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 0.9625, constant: 0.0))
        send.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        save.translatesAutoresizingMaskIntoConstraints = false
        save.setImage(UIImage(named: "iconSave"), for: .normal)
        addConstraint(NSLayoutConstraint(item: save, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 0.04, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: save, attribute: .width, relatedBy: .equal, toItem: save, attribute: .height, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: save, attribute: .centerY, relatedBy: .equal, toItem: send, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        save.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(named: "iconBack"), for: .normal)
        addConstraint(NSLayoutConstraint(item: back, attribute: .width, relatedBy: .equal, toItem: back, attribute: .height, multiplier: 1.0, constant: 0.0))
        back.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addConstraint(NSLayoutConstraint(item: back, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: back, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
