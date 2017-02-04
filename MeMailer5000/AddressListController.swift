//
//  AddressListController.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

protocol AddressListViewModelProtocol {
    var numberOfSections: Int { get }
    
    func numberOfRows(in section: Int) -> Int
    
    func title(for indexPath: IndexPath) -> String
    
    func subtitle(for indexPath: IndexPath) -> String
}

class AddressListController: UITableViewController {
    
    var viewModel: AddressListViewModelProtocol = AddressListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Send To..."
        let addAddress = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddressTapped))
        navigationItem.rightBarButtonItem = addAddress
        
        let nib = UINib(nibName: String(describing: AddressCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: AddressCell.self))
    }
    
    func addAddressTapped() {
        let storyBoard = UIStoryboard(name: "AddAddress", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AddAddressController")
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
