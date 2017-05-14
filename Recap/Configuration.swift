//
//  Configuration.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 3/12/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

enum Environment {
    case test
    case debug
    case production
    
    var authorizationValue: String {
        switch self {
        case .test:
            return "test_0dc8d51e0acffcb1880e0f19c79b2f5b0cc"
        case .debug:
            return "test_3f5d20f0882cd26b96fbabe1a4161a5285f"
        case .production:
            return "live_ed74f56ea5718cf79eeaa1f9fc1a2b96970"
        }
    }
}

struct AWSCredentials {
    static let identityPoolId = "us-east-1:339d75ae-6cbc-4980-9770-361f403477ca"
}
