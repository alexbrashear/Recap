//
//  SettingsViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 5/14/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import SafariServices

enum SettingsSection: Int {
    case address
    case support
    case facebook
    case legal
    
    var title: String {
        switch self {
        case .address: return "Address"
        case .support: return "Support"
        case .facebook: return ""
        case .legal: return "Legal"
        }
    }
    
    var rows: [SettingsRow] {
        switch self {
        case .address:
            return [.address]
        case .support:
            return [.sendFeedback, .faqs]
        case .facebook:
            return [.logInToFacebook]
        case .legal:
            return [.termsOfService, .privacyPolicy]
        }
    }
    
    static let count = 4
}

enum SettingsRow {
    case address
    case faqs
    case sendFeedback
    case logInToFacebook
    case termsOfService
    case privacyPolicy
    
    var cellStyle: UITableViewCellStyle {
        switch self {
        case .address:
            return .subtitle
        case .sendFeedback, .logInToFacebook, .faqs, .termsOfService, .privacyPolicy:
            return .default
        }
    }
}

class SettingsViewModel: SettingsViewModelProtocol {
    
    let userController: UserController
    let enterAddress: () -> Void
    let feedbackAction: () -> Void
    let connectFacebook: () -> Void
    
    init(userController: UserController, enterAddress: @escaping () -> Void, feedbackAction: @escaping () -> Void, connectFacebook: @escaping () -> Void) {
        self.userController = userController
        self.enterAddress = enterAddress
        self.feedbackAction = feedbackAction
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
        case .faqs:
            return "FAQs"
        case .logInToFacebook:
            return userController.isLoggedIntoFacebook ? "facebook: Logged in" : "facebook: not logged in"
        case .privacyPolicy:
            return "Privacy Policy"
        case .termsOfService:
            return "Terms of Service"
        }
    }
    
    private func subtitleForRow(row: SettingsRow) -> String? {
        switch row {
        case .address:
            guard let address = userController.user?.address else { return "" }
            return "\(address.line1) \(address.line2)"
        case .logInToFacebook, .sendFeedback, .faqs, .privacyPolicy, .termsOfService:
            return nil
        }
    }
    
    func didSelectRow(at indexPath: IndexPath, vc: SettingsViewController) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        let row = section.rows[indexPath.row]
        switch row {
        case .address:
            enterAddress()
        case .sendFeedback:
            feedbackAction()
        case .faqs:
            let svc = SFSafariViewController(url: StaticURLs.faqs, entersReaderIfAvailable: true)
            svc.delegate = vc
            vc.present(svc, animated: true, completion: nil)
        case .privacyPolicy:
            let svc = SFSafariViewController(url: StaticURLs.privacyPolicy, entersReaderIfAvailable: true)
            svc.delegate = vc
            vc.present(svc, animated: true, completion: nil)
        case .termsOfService:
            let svc = SFSafariViewController(url: StaticURLs.termsOfService, entersReaderIfAvailable: true)
            svc.delegate = vc
            vc.present(svc, animated: true, completion: nil)
        case .logInToFacebook:
            connectFacebook()
        }
    }
}
