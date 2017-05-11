//
//  PhotoSendingView.swift
//  Recap
//
//  Created by Alex Brashear on 4/30/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

enum AlertKind {
    case successfulSend
    case errorSending(Error)
    case savedToLibrary
    case errorSavingToLibrary(Error)
    case uploadingRecap
    
    var title: String {
        switch self {
        case .successfulSend:
            return "Recap sent"
        case .uploadingRecap:
            return "Uploading your Recap"
        case .savedToLibrary:
            return "Saved to library"
        case .errorSavingToLibrary:
            return "Sorry, we couldn't save your photo"
        case .errorSending:
            return "Sorry, we couldn’t send your Recap"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .successfulSend:
            return UIImage(named: "success")
        case .uploadingRecap:
            return UIImage(named: "loading")
        case .savedToLibrary:
            return UIImage(named: "success")
        case .errorSavingToLibrary, .errorSending:
            return nil
        }
    }
    
    var viewModel: SimpleImageLabelAlertViewModelProtocol {
        switch self {
        case .successfulSend, .savedToLibrary, .uploadingRecap:
            return PositiveAlertViewModel(title: title, image: image)
        case .errorSending:
            return ErrorAlertViewModel()
        case .errorSavingToLibrary:
            return ErrorAlertViewModel()
        }
    }
}

protocol SimpleImageLabelAlertViewModelProtocol: class {
    var title: NSAttributedString { get }
    var subtitle: NSAttributedString? { get }
    var accessory: UIImage? { get }
    var background: UIColor { get }
    var kind: SimpleImageLabelAlert.Kind { get }
}

class SimpleImageLabelAlert: UIView {
    
    enum Kind {
        case oneLineImage
        case twoLine
    }
    
    let title = UILabel()
    let subtitle = UILabel()
    let loading = UIImageView()
    
    init(frame: CGRect, viewModel: SimpleImageLabelAlertViewModelProtocol) {
        super.init(frame: frame)
        
        backgroundColor = viewModel.background
        
        title.attributedText = viewModel.title
        title.numberOfLines = 1
        
        subtitle.attributedText = viewModel.subtitle
        subtitle.numberOfLines = 1
        
        loading.image = viewModel.accessory
        loading.contentMode = .scaleAspectFit
        
        let stack = stackView(for: viewModel.kind)
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: stack, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 15))
        addConstraint(NSLayoutConstraint(item: stack, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -15))
        addConstraint(NSLayoutConstraint(item: stack, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10))
        addConstraint(NSLayoutConstraint(item: stack, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -10))
    }
    
    private func stackView(for kind: Kind) -> UIStackView {
        let stack = UIStackView()
        switch kind {
        case .oneLineImage:
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.alignment = .fill
            stack.addArrangedSubview(loading)
            stack.addArrangedSubview(title)
            stack.spacing = 10
        case .twoLine:
            stack.axis = .vertical
            stack.distribution = .fill
            stack.alignment = .fill
            stack.addArrangedSubview(title)
            stack.addArrangedSubview(subtitle)
            stack.spacing = 10
        }
        return stack
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
