//
//  FilmError.swift
//  Recap
//
//  Created by Alex Brashear on 7/26/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

enum PhotoError: Error {
    case unknownFailure
    case noFilmError
    case unableToSaveImageLocally
    case uploadToS3Failure
    case uploadToScapholdFailure
    
    var localizedTitle: String {
        return "Slight hiccup"
    }
    
    var localizedDescription: String {
        switch self {
        case .unknownFailure:
            return "Unknown failure"
        case .noFilmError:
            return "You're out of film! Tap the number at the bottom of your screen to get more"
        case .unableToSaveImageLocally:
            return "Unable to save image locally"
        case .uploadToS3Failure:
            return "We ran into a problem uploading your photo. Check your internet connection and try again!"
        case .uploadToScapholdFailure:
            return "We ran into a problem sending your photo. Check your internet connection and try again!"
        }
    }
    
    var alert: UIAlertController {
        return UIAlertController.okAlert(title: localizedTitle, message: localizedDescription)
    }
}
