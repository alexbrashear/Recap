//
//  UsedFilmListController.swift
//  Recap
//
//  Created by Alex Brashear on 5/18/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

protocol UsedFilmListViewModelProtocol: class {
    var rowTapHandler: () -> Void { get }
}

class UsedFilmListController: UITableViewController {
    
    var viewModel: UsedFilmListViewModelProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(cellType: FilmRollCell.self)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        // Removes the cell separators for empty cells
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FilmRollCell = tableView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.rowTapHandler()
    }
}
