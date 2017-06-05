//
//  FilmViewController.swift
//  Recap
//
//  Created by Alex Brashear on 5/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

class FilmViewController: UITableViewController {
    
    var photos: [Photo]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(cellType: SinglePhotoCell.self)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let photo = photos?[indexPath.row] else { return UITableViewCell() }
        let cell: SinglePhotoCell = tableView.dequeueReusableCell(for: indexPath)
        cell.viewModel = SinglePhotoCell.ViewModel(photoURL: photo.imageURL, statusAccessory: UIImage(named: "RCPDarkCheck")!, status: "DELIVERED", deliveryDate: "4/21/23")
        return cell
    }
}
