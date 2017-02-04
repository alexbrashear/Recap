//
//  AddAddressController.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class AddAddressController: UIViewController {
    
    private let addAddressView = AddAddressView.loadFromNib()
    @IBOutlet private var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Add an address"
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancel
        
        contentView.addSubview(addAddressView)
        addAddressView.constrainToSuperview()
        view.addSubview(contentView)
    }
    
    func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
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
