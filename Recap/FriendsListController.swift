//
//  FriendsListController.swift
//  Recap
//
//  Created by Alex Brashear on 9/11/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

protocol FriendsListViewModelProtocol: class {
    var topBarText: String { get }
    var bottomBarText: String { get }
    var shouldShowBottomBar: Bool { get }
    
    var numberOfSections: Int { get }
    func numberOfRows(in section: Int) -> Int
    func titleForRow(at indexPath: IndexPath) -> String
    
    var canSelect: Bool { get }
    func didSelect(indexPath: IndexPath)
    func didDeselect(indexPath: IndexPath)
}

class FriendsListController: UIViewController {
    
    var viewModel: FriendsListViewModelProtocol!
    
    var topBar = FriendsListTopBar(frame: .zero)
    var tableView: UITableView!
    var bottomBar = FriendsListBottomBar(frame: .zero)
    var bottomBarHeight: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        // constraining a view to the view's topanchor will no longer extend under the
        // navigation bar
        edgesForExtendedLayout = []
        
        // Setting the background color explicitly solved an issue
        // with jumpy transitions
        view.backgroundColor = .white
        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white
        
        view.addSubview(topBar)
        view.addSubview(tableView)
        view.addSubview(bottomBar)
        
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        topBar.setText(viewModel.topBarText)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topBar.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomBarHeight = bottomBar.heightAnchor.constraint(equalToConstant: 0)
        bottomBarHeight?.isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor).isActive = true
        
        tableView.register(cellType: FriendCell.self)
        tableView.allowsMultipleSelection = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func bottomBarNeedsUpdate() {
        guard viewModel.shouldShowBottomBar else {
            return animateBottomBarToHeight(height: 0)
        }

        bottomBar.setText(viewModel.bottomBarText)
        animateBottomBarToHeight(height: 60)
    }
    
    func animateBottomBarToHeight(height: CGFloat) {
        guard let constant = bottomBarHeight?.constant,
            constant != height else { return }
        bottomBarHeight?.isActive = false
        bottomBarHeight = bottomBar.heightAnchor.constraint(equalToConstant: height)
        bottomBarHeight?.isActive = true
        UIView.animate(withDuration: 0.2) { self.view.layoutIfNeeded() }
    }
}

extension FriendsListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as FriendCell
        let name = viewModel.titleForRow(at: indexPath)
        cell.viewModel = FriendCell.ViewModel(name: name)
        return cell
    }
}

extension FriendsListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard viewModel.canSelect else { return nil }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(indexPath: indexPath)
        topBar.setText(viewModel.topBarText)
        bottomBarNeedsUpdate()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.didDeselect(indexPath: indexPath)
        topBar.setText(viewModel.topBarText)
        bottomBarNeedsUpdate()
    }
}
