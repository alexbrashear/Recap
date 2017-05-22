//
//  SettingsViewController.swift
//  Recap
//
//  Created by Alex Brashear on 5/7/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

protocol SettingsViewModelProtocol: class {
    
}

class SettingsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingsSection(rawValue: section)?.title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        let cell: UITableViewCell
        switch section {
        case .address:
            cell = tableView.dequeueReusableCell(withIdentifier: "address") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "address")
            cell.textLabel?.text = "Alex Brashear"
            cell.detailTextLabel?.text = "132 Saint Marks Place apt 7"
        case .support:
            cell = tableView.dequeueReusableCell(withIdentifier: "default") ?? UITableViewCell(style: .default, reuseIdentifier: "default")
            cell.textLabel?.text = "Send Feedback"
        case .legal:
            cell = tableView.dequeueReusableCell(withIdentifier: "default") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "default")
            cell.textLabel?.text = "Terms and Conditions"
        }
        
        return cell
    }
}
