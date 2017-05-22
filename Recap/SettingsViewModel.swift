//
//  SettingsViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 5/14/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

enum SettingsSection: Int {
    case address
    case support
    case legal
    
    var title: String {
        switch self {
        case .address: return "Address"
        case .support: return "Support"
        case .legal:   return "Legal"
        }
    }
}

enum SettingsRow {
    case address
    case feedback
    case termsAndConditions
}


