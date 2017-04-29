//
//  PhotoTakenView.swift
//  Recap
//
//  Created by Alex Brashear on 4/28/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

typealias SendPhotoAction = () -> Void
typealias DeletePhotoAction = () -> Void
typealias SavePhotoAction = () -> Void

protocol PhotoTakeViewModelProtocol: class  {
    var sendPhotoAction: SendPhotoAction { get }
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
                self.viewModel?.sendPhotoAction()
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
        addConstraint(NSLayoutConstraint(item: send, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 0.92, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: send, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -30.0))
        
        save.translatesAutoresizingMaskIntoConstraints = false
        save.setImage(UIImage(named: "iconSave"), for: .normal)
        addConstraint(NSLayoutConstraint(item: save, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 0.08, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: save, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -30.0))
        
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setImage(UIImage(named: "iconBack"), for: .normal)
        addConstraint(NSLayoutConstraint(item: back, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 0.04, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: back, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 30.0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
