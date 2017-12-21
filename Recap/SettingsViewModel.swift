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
    case user
    case legal
    case forgetCreditCard
    
    var title: String {
        switch self {
        case .address: return "Address"
        case .support: return "Support"
        case .user: return ""
        case .legal: return "Legal"
        case .forgetCreditCard: return ""
        }
    }
    
    var rows: [SettingsRow] {
        switch self {
        case .address:
            return [.address]
        case .support:
            return [.sendFeedback, .faqs]
        case .user:
            return [.logInToFacebook]
        case .legal:
            return [.termsOfService, .privacyPolicy]
        case .forgetCreditCard:
            return [.forgetCreditCard]
        }
    }
    
    static let count = 5
}

enum SettingsRow {
    case address
    case faqs
    case sendFeedback
    case logInToFacebook
    case termsOfService
    case privacyPolicy
    case forgetCreditCard
    
    var cellStyle: UITableViewCellStyle {
        switch self {
        case .address:
            return .subtitle
        default:
            return .default
        }
    }
    
    var actionStyle: UITableViewRowActionStyle {
        switch self {
        case .forgetCreditCard:
            return .destructive
        default:
            return .normal
        }
    }
    
    var selectionStyle: UITableViewCellSelectionStyle {
        return .default
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
    
    func actionStyleForRow(at indexPath: IndexPath) -> UITableViewRowActionStyle {
        guard let row = row(at: indexPath) else { return .normal }
        return row.actionStyle
    }
    
    func styleForRow(at indexPath: IndexPath) -> UITableViewCellStyle {
        guard let row = row(at: indexPath) else { return .default }
        return row.cellStyle
    }
    
    func selectionStyleForRow(at indexPath: IndexPath) -> UITableViewCellSelectionStyle {
        guard let row = row(at: indexPath) else { return .default }
        return row.selectionStyle
    }
    
    func subtitleForRow(at indexPath: IndexPath) -> String? {
        guard let row = row(at: indexPath) else { return nil }
        return subtitleForRow(row: row)
    }
    
    func titleForRow(at indexPath: IndexPath) -> String {
        guard let row = row(at: indexPath) else { return "" }
        return titleForRow(row: row)
    }
    
    private func row(at indexPath: IndexPath) -> SettingsRow? {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return nil }
        return section.rows[indexPath.row]
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
            return userController.isLoggedIntoFacebook ? "facebook: Logged in" : "Log in to Facebook"
        case .privacyPolicy:
            return "Privacy Policy"
        case .termsOfService:
            return "Terms of Service"
        case .forgetCreditCard:
            return "Delete Payment Info"
        }
    }
    
    private func subtitleForRow(row: SettingsRow) -> String? {
        switch row {
        case .address:
            guard let address = userController.user?.address else { return "" }
            return "\(address.primaryLine) \(address.secondaryLine)"
        default:
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
        case .forgetCreditCard:
            userController.deletePaymentInformation()
            let alert = UIAlertController.okAlert(title: "We deleted your payment information!", message: nil)
            vc.presentAlert(alert)
        }
    }
}
