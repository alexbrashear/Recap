//
//  SettingsViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 5/14/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

enum SettingsSection: Int {
    case address
    case support
    case facebook
    
    var title: String {
        switch self {
        case .address: return "Address"
        case .support: return "Support"
        case .facebook: return ""
        }
    }
    
    var rows: [SettingsRow] {
        switch self {
        case .address:
            return [.address]
        case .support:
            return [.sendFeedback]
        case .facebook:
            return [.logInToFacebook]
        }
    }
    
    static let count = 3
}

enum SettingsRow {
    case address
    case sendFeedback
    case logInToFacebook
    
    var cellStyle: UITableViewCellStyle {
        switch self {
        case .address:
            return .subtitle
        case .sendFeedback, .logInToFacebook:
            return .default
        }
    }
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    init() {
        
    }
    
    var numberOfSections: Int {
        return SettingsSection.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let settingsSection = SettingsSection(rawValue: section) else { return 0 }
        return settingsSection.rows.count
    }
    
    func title(for section: Int) -> String {
        guard let settingsSection = SettingsSection(rawValue: section) else { return "" }
        return settingsSection.title
    }
    
    func styleForRow(at indexPath: IndexPath) -> UITableViewCellStyle {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return .default }
        let row = section.rows[indexPath.row]
        return row.cellStyle
    }
    
    func subtitleForRow(at indexPath: IndexPath) -> String? {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return nil }
        let row = section.rows[indexPath.row]
        return subtitleForRow(row: row)
    }
    
    func titleForRow(at indexPath: IndexPath) -> String {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return "" }
        let row = section.rows[indexPath.row]
        return titleForRow(row: row)
    }
    
    private func titleForRow(row: SettingsRow) -> String {
        switch row {
        case .address:
            return "Test"
        case .sendFeedback:
            return "Send Feedback"
        case .logInToFacebook:
            return "NO"
        }
    }
    
    private func subtitleForRow(row: SettingsRow) -> String? {
        switch row {
        case .address:
            return "TestTest"
        case .logInToFacebook, .sendFeedback:
            return nil
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        return
    }
}
