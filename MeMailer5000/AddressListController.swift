//
//  AddressListController.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import YapDatabase
import PKHUD

protocol AddressListViewModelProtocol {
    var numberOfSections: Int { get }
    
    func numberOfRows(in section: Int) -> Int
    
    func title(for indexPath: IndexPath) -> String
    
    func subtitle(for indexPath: IndexPath) -> String
    
    func didSelectRow(at indexPath: IndexPath, image: UIImage?, completion: @escaping (PostcardError?) -> Void)
}

class AddressListController: UITableViewController {
    
    var viewModel: AddressListViewModelProtocol = AddressListViewModel(addresses: [])
    
    var image: UIImage?
    
    let databaseConnection = DatabaseController.sharedInstance.newWritingConnection()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        readData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(yapDatabaseModified), name: NSNotification.Name.YapDatabaseModified, object: DatabaseController.sharedInstance.yapDatabase)
        
        title = "Send To..."
        let addAddress = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddressTapped))
        navigationItem.rightBarButtonItem = addAddress
        
        let nib = UINib(nibName: String(describing: AddressCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: AddressCell.self))
    }
    
    func yapDatabaseModified(notification: Notification) {
        readData()
        tableView.reloadData()
    }
    
    func readData() {
        databaseConnection.beginLongLivedReadTransaction()
        var addresses: [Address]?
        databaseConnection.read { transaction in
            addresses = transaction.object(forKey: "addresses", inCollection: "addresses") as? [Address]
        }
        if let addresses = addresses {
            viewModel = AddressListViewModel(addresses: addresses)
        }
    }
    
    func addAddressTapped() {
        let storyBoard = UIStoryboard(name: "AddAddress", bundle: nil)
        guard let viewController = storyBoard.instantiateViewController(withIdentifier: "AddAddressController") as? AddAddressController else {
            return
        }
        let nc = UINavigationController(rootViewController: viewController)
        navigationController?.present(nc, animated: true, completion: nil)
    }
}

// MARK: - TableViewDataSource

extension AddressListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddressCell.self)) as? AddressCell else { return UITableViewCell() }

        let title = viewModel.title(for: indexPath)
        let subtitle = viewModel.subtitle(for: indexPath)
        cell.viewModel = AddressCell.ViewModel(title: title, subtitle: subtitle)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AddressListController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HUD.show(.progress)
        viewModel.didSelectRow(at: indexPath, image: image) { [weak self] error in
            DispatchQueue.main.async {
                HUD.hide()
                self?.runCompletion(error: error)
            }
        }
    }
    
    private func runCompletion(error: PostcardError?) {
        if let error = error {
            let alertController = UIAlertController(title: error.localizedTitle, message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        } else {
            HUD.show(.success)
            HUD.hide(afterDelay: 0.5) { finished in
                print("success")
            }
        }
    }
}
