//
//  PostcardError.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/20/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

enum PostcardError: Error {
    case unknownFailure
    case unableToSaveImageLocally
    case uploadToS3Failure
    case parsingFailure
    
    var localizedTitle: String {
        return "Error"
    }
    
    var localizedDescription: String {
        switch self {
        case .unknownFailure:
            return "Unknown failure"
        case .unableToSaveImageLocally:
            return "Unable to save image locally"
        case .uploadToS3Failure:
            return "There was an issue uploading the image to the server"
        case .parsingFailure:
            return "the postcard was sent but there was an error retrieving metadata about the card"
        }
    }
}
