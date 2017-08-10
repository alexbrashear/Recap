//
//  AlertableError.swift
//  Recap
//
//  Created by Alex Brashear on 8/10/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

protocol AlertableError: Error {
    var localizedTitle: String { get }
    
    var alert: UIAlertController { get }
}

extension AlertableError {
    var alert: UIAlertController {
        return UIAlertController.okAlert(title: localizedTitle, message: localizedDescription)
    }
}
