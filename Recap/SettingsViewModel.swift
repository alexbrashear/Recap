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
    
    let userController: UserController
    let enterAddress: () -> Void
    let connectFacebook: () -> Void
    
    init(userController: UserController, enterAddress: @escaping () -> Void, connectFacebook: @escaping () -> Void) {
        self.userController = userController
        self.enterAddress = enterAddress
        self.connectFacebook = connectFacebook
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
            let name = userController.user?.address.name
            assert(name != nil)
            return name ?? ""
        case .sendFeedback:
            return "Send Feedback"
        case .logInToFacebook:
            return userController.isLoggedIntoFacebook ? "facebook: Logged in" : "facebook: not logged in"
        }
    }
    
    private func subtitleForRow(row: SettingsRow) -> String? {
        switch row {
        case .address:
            guard let address = userController.user?.address else { return "" }
            return "\(address.line1) \(address.line2)"
        case .logInToFacebook, .sendFeedback:
            return nil
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        let row = section.rows[indexPath.row]
        switch row {
        case .address:
            enterAddress()
        case .sendFeedback:
            return
        case .logInToFacebook:
            connectFacebook()
        }
    }
}
