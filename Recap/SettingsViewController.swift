//
//  SettingsViewController.swift
//  Recap
//
//  Created by Alex Brashear on 5/7/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices

protocol SettingsViewModelProtocol {
    var numberOfSections: Int { get }
    func actionStyleForRow(at indexPath: IndexPath) -> UITableViewRowActionStyle
    func selectionStyleForRow(at indexPath: IndexPath) -> UITableViewCellSelectionStyle
    func numberOfRows(in section: Int) -> Int
    func title(for section: Int) -> String
    func styleForRow(at indexPath: IndexPath) -> UITableViewCellStyle
    func titleForRow(at indexPath: IndexPath) -> String
    func subtitleForRow(at indexPath: IndexPath) -> String?
    
    func didSelectRow(at indexPath: IndexPath, vc: SettingsViewController)
}

class SettingsViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    var viewModel: SettingsViewModelProtocol!

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
        
        NotificationCenter.default.addObserver(forName: UserNotification.userDidUpdate, object: nil, queue: .main) { [weak self] _ in
            self?.tableView.reloadData()
        }
    }
    
    func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(for: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let style = viewModel.styleForRow(at: indexPath)
        let identifier = style == .subtitle ? "subtitle" : "default"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) ?? UITableViewCell(style: style, reuseIdentifier: identifier)
        
        cell.textLabel?.text = viewModel.titleForRow(at: indexPath)
        cell.detailTextLabel?.text = viewModel.subtitleForRow(at: indexPath)
        
        if viewModel.actionStyleForRow(at: indexPath) == .destructive {
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .red
        }
        
        cell.selectionStyle = viewModel.selectionStyleForRow(at: indexPath)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath, vc: self)
    }
}

extension SettingsViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
