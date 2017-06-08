//
//  UsedFilmListController.swift
//  Recap
//
//  Created by Alex Brashear on 5/18/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Reusable

typealias FilmRowTapHandler = (Film) -> Void

protocol UsedFilmListViewModelProtocol: class {
    var rowTapHandler: FilmRowTapHandler { get }
}

class UsedFilmListController: UITableViewController {
    
    var viewModel: UsedFilmListViewModelProtocol?
    let emptyView = EmptyFilmList.loadFromNib()
    
    var filmSnapshot: [Film]? {
        didSet {
            if filmSnapshot == nil || filmSnapshot?.count == 0 || !hasPhotos(forSnapshot: filmSnapshot ?? []) {
                tableView.backgroundView = emptyView
                filmSnapshot = nil
            } else {
                tableView.backgroundView = nil
            }
            tableView.reloadData()
        }
    }
    
    func hasPhotos(forSnapshot snap: [Film]) -> Bool {
        for film in snap {
            if !film.isEmpty { return true }
        }
        return false
    }

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
        return filmSnapshot?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let film = filmSnapshot?[indexPath.row] else { return UITableViewCell() }
        let cell: FilmRollCell = tableView.dequeueReusableCell(for: indexPath)
        cell.film = film
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let film = filmSnapshot?[indexPath.row] else { return }
        viewModel?.rowTapHandler(film)
    }
}
