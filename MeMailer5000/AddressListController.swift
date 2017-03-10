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

/// typealias for a closure to be called after a user selects a row and the transaction was successful
typealias SelectedAddressCompletionBlock = () -> Void

protocol AddressListViewModelProtocol: class {
    var selectedAddressCompletionBlock: SelectedAddressCompletionBlock { get }
    
    var numberOfSections: Int { get }
        
    func numberOfRows(in section: Int) -> Int
    
    func title(for indexPath: IndexPath) -> String
    
    func subtitle(for indexPath: IndexPath) -> String
    
    func didSelectRow(at indexPath: IndexPath, image: UIImage?, completion: @escaping (PostcardError?) -> Void)
    
    func observeDataChanges(withBlock block: (() -> Void)?)
}

class AddressListController: UITableViewController {
    
    var viewModel: AddressListViewModelProtocol?
    
    var image: UIImage?
    
    let databaseConnection = DatabaseController.sharedInstance.newWritingConnection()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Send To..."
        
        let nib = UINib(nibName: String(describing: AddressCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: AddressCell.self))
        
        viewModel?.observeDataChanges { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableViewDataSource

extension AddressListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.numberOfRows(in: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddressCell.self)) as? AddressCell,
              let viewModel = viewModel else { return UITableViewCell() }

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
        viewModel?.didSelectRow(at: indexPath, image: image) { [weak self] error in
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
            HUD.hide(afterDelay: 0.5) { [weak self] finished in
                self?.viewModel?.selectedAddressCompletionBlock()
            }
        }
    }
}
