//
//  SettingsViewController.swift
//  Recap
//
//  Created by Alex Brashear on 5/7/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    
    var address: Address? {
        didSet {
            guard tableView != nil else { return }
            tableView.reloadData()
        }
    }
    
    var isLoggedInToFacebook: Bool = false {
        didSet {
            guard tableView != nil else { return }
            if oldValue != isLoggedInToFacebook {
                tableView.reloadData()
            }
        }
    }
    
    var changeAddress: (() -> Void)?
    
    var connectSocial: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        
        tableView = UITableView(frame: .zero, style: .grouped)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingsSection(rawValue: section)?.title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        let cell: UITableViewCell
        switch section {
        case .address:
            cell = tableView.dequeueReusableCell(withIdentifier: "address") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "address")
            cell.textLabel?.text = address?.name
            cell.detailTextLabel?.text = "\(address?.line1 ?? "") \(address?.line2 ?? "")"
        case .support:
            cell = tableView.dequeueReusableCell(withIdentifier: "default") ?? UITableViewCell(style: .default, reuseIdentifier: "default")
            cell.textLabel?.text = "Send Feedback"
        case .facebook:
            cell = tableView.dequeueReusableCell(withIdentifier: "default") ?? UITableViewCell(style: .default, reuseIdentifier: "default")
            let str = isLoggedInToFacebook ? "facebook: Logged in" : "facebook: not logged in"
            cell.textLabel?.text = str
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        switch section {
        case .address:
            changeAddress?()
        case .support:
            let vc = MFMailComposeViewController()
            vc.mailComposeDelegate = self
            vc.setToRecipients(["help@recap-app.com"])
            vc.setSubject("I've got feedback!")
            vc.setMessageBody("", isHTML: false)
            if MFMailComposeViewController.canSendMail() {
                self.present(vc, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        case .facebook:
            connectSocial?()
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Access Mail", message: "Unfortunately we could not access your mail client but we saved help@recap-app.com to your clipboard, shoot us an email! Thanks!", preferredStyle: .alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        UIPasteboard.general.string = "help@recap-app.com"
        present(sendMailErrorAlert, animated: true, completion: nil)
    }
}
