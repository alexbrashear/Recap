//
//  WelcomeViewController.swift
//  Recap
//
//  Created by Alex Brashear on 4/18/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

protocol WelcomeViewModelProtocol {
    var continueButtonAction: ContinueButtonAction { get }
    
    var items: [WelcomeItem.ViewModel] { get }
}

class WelcomeViewController: UIViewController {
    
    @IBOutlet var tagline: UILabel!
    @IBOutlet var item1: UIView!
    @IBOutlet var item2: UIView!
    @IBOutlet var item3: UIView!
    @IBOutlet var continueButton: UIButton!
    
    let subItem1 = WelcomeItem.loadFromNib()
    let subItem2 = WelcomeItem.loadFromNib()
    let subItem3 = WelcomeItem.loadFromNib()
    
    var viewModel: WelcomeViewModelProtocol? {
        didSet {
            guard let viewModel = viewModel else { return }
            subItem1.viewModel = viewModel.items[0]
            subItem2.viewModel = viewModel.items[1]
            subItem3.viewModel = viewModel.items[2]
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        item1.addSubview(subItem1)
        item2.addSubview(subItem2)
        item3.addSubview(subItem3)
        
        subItem1.constrainToSuperview()
        subItem2.constrainToSuperview()
        subItem3.constrainToSuperview()
        
        continueButton.layer.cornerRadius = 5
        continueButton.clipsToBounds = true
        continueButton.titleLabel?.font = UIFont.openSansBoldFont(ofSize: 20.0)
        
        tagline.font = UIFont.openSansBoldFont(ofSize: 20.0)
        
        continueButton.on(.touchUpInside) { [weak self] _ in
            self?.viewModel?.continueButtonAction()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

/**
 Extends `UIView` with convenience methods for size classes
 */
extension UIView {
    /// Constrains a view to its superview. If the view does not have a superview, this function has no effect.
    func constrainToSuperview() {
        if let superview = superview {
            translatesAutoresizingMaskIntoConstraints = false
            leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
            trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            widthAnchor.constraint(equalTo: superview.widthAnchor).isActive = true
            heightAnchor.constraint(equalTo: superview.heightAnchor).isActive = true
        }
    }
}
