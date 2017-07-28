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
    case parsingFailure
    case dateParsingFailure
    
    var localizedTitle: String {
        return "Error"
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
            return "There was an issue uploading the image to the server"
        case .parsingFailure:
            return "the postcard was sent but there was an error retrieving metadata about the card"
        case .dateParsingFailure:
            return "there was an error acquiring the timestamp for this postcard"
        }
    }
    
    var alert: UIAlertController {
        return UIAlertController.okAlert(title: localizedTitle, message: localizedDescription)
    }
}
