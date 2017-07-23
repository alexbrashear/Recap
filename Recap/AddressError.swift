//
//  AddressError.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

enum AddressError: Error {
    case unknownFailure
    case notEnoughInformation
    
    var localizedTitle: String {
        switch self {
        case .unknownFailure:
            return "Error"
        case .notEnoughInformation:
            return "More Information Required"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .unknownFailure:
            return "Unable to find address, check that you entered a valid address, city, state and zipcode"
        case .notEnoughInformation:
            return "The address you entered was found but more information is needed (such as an apartment, suite, or box number) to match to a specific address."
        }
    }
    
    var alert: UIAlertController {
        return UIAlertController.okAlert(title: localizedTitle, message: localizedDescription)
    }
}
