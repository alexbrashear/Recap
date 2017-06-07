//
//  PhotoSendingView.swift
//  Recap
//
//  Created by Alex Brashear on 4/30/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import PKHUD

enum AlertKind {
    case successfulSend
    case savedToLibrary
    case uploadingRecap
    
    var title: String {
        switch self {
        case .successfulSend:
            return "Recap sent"
        case .uploadingRecap:
            return "Uploading your Recap"
        case .savedToLibrary:
            return "Saved to library"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .successfulSend, .savedToLibrary:
            return UIImage(named: "success")
        case .uploadingRecap:
            return UIImage(named: "loading")
        }
    }
    
    var viewModel: SimpleImageLabelAlertViewModelProtocol {
        switch self {
        case .successfulSend, .savedToLibrary, .uploadingRecap:
            return PositiveAlertViewModel(title: title, image: image)
        }
    }
    
    var loading: Bool {
        switch self {
        case .uploadingRecap:
            return true
        default:
            return false
        }
    }
}

protocol SimpleImageLabelAlertViewModelProtocol: class {
    var title: NSAttributedString { get }
    var subtitle: NSAttributedString? { get }
    var accessory: UIImage? { get }
    var background: UIColor { get }
}

class SimpleImageLabelAlert: UIView {
    
    static var uploading: SimpleImageLabelAlert {
        let rect = CGRect(x: 0, y: 0, width: 230, height: 50)
        return SimpleImageLabelAlert(frame: rect, viewModel: AlertKind.uploadingRecap.viewModel, animate: true)
    }
    
    static var successfulSend: SimpleImageLabelAlert {
        let rect = CGRect(x: 0, y: 0, width: 150, height: 40)
        return SimpleImageLabelAlert(frame: rect, viewModel: AlertKind.successfulSend.viewModel)
    }
    
    static var successfulSave: SimpleImageLabelAlert {
        let rect = CGRect(x: 0, y: 0, width: 200, height: 40)
        return SimpleImageLabelAlert(frame: rect, viewModel: AlertKind.savedToLibrary.viewModel)
    }
    
    let title = UILabel()
    let subtitle = UILabel()
    let loading = UIImageView()
    
    init(frame: CGRect, viewModel: SimpleImageLabelAlertViewModelProtocol, animate: Bool = false) {
        super.init(frame: frame)
        
        backgroundColor = viewModel.background
        
        title.attributedText = viewModel.title
        title.numberOfLines = 1
        
        subtitle.attributedText = viewModel.subtitle
        subtitle.numberOfLines = 1
        
        loading.image = viewModel.accessory
        loading.contentMode = .scaleAspectFit
        if animate {
            loading.layer.add(PKHUDAnimation.discreteRotation, forKey: "progressAnimation")
        }
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.addArrangedSubview(loading)
        stack.addArrangedSubview(title)
        stack.spacing = 10
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: stack, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 15))
        addConstraint(NSLayoutConstraint(item: stack, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -15))
        addConstraint(NSLayoutConstraint(item: stack, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: stack, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -10))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
