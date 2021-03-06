//
//  FriendsListController.swift
//  Recap
//
//  Created by Alex Brashear on 9/11/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

typealias UpdateToolbars = () -> Void

protocol FriendsListViewModelProtocol: class {
    var topBarText: String { get }
    var topBarTapHandler: () -> Void { get }
    var bottomBarText: String { get }
    var shouldShowBottomBar: Bool { get }
    
    func cellType(for indexPath: IndexPath) -> FriendsListController.CellType
    var numberOfSections: Int { get }
    func titleForHeader(in section: Int) -> String?
    func numberOfRows(in section: Int) -> Int
    func titleForRow(at indexPath: IndexPath) -> String
    
    func canSelect(indexPath: IndexPath) -> Bool
    func didSelect(indexPath: IndexPath)
    func didDeselect(indexPath: IndexPath)
    func didSend()
    
    func refreshFriendSnapshot()
}

class FriendsListController: UIViewController {
    
    var viewModel: FriendsListViewModelProtocol!
    
    enum CellType {
        case friend
        case link
    }
    
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
        topBar.addTarget(self, action: #selector(didTapTopBar), for: .touchUpInside)
        
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
        tableView.register(cellType: LinkCell.self)
        tableView.allowsMultipleSelection = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(forName: FriendNotification.facebookUpdated, object: nil, queue: .main) { [weak self] _ in
            self?.viewModel.refreshFriendSnapshot()
            self?.tableView.reloadData()
        }
        NotificationCenter.default.addObserver(forName: FriendNotification.friendAdded, object: nil, queue: .main) { [weak self] _ in
            self?.viewModel.refreshFriendSnapshot()
            self?.tableView.reloadData()
        }
        
        bottomBar.setAction { [weak self] in
            self?.viewModel.didSend()
        }
    }
    
    @objc func didTapTopBar() {
        viewModel.topBarTapHandler()
    }
    
    func bottomBarNeedsUpdate() {
        guard viewModel.shouldShowBottomBar else {
            return animateBottomBarToHeight(height: 0)
        }

        bottomBar.setText(viewModel.bottomBarText)
        var height: CGFloat = 60
        if #available(iOS 11, *) {
            height += view.safeAreaInsets.bottom
        }
        animateBottomBarToHeight(height: height)
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
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.rcpBlueyGrey
        header.backgroundView?.backgroundColor = .white
        header.textLabel?.font = UIFont.openSansBoldFont(ofSize: 12)
        guard let frame = header.textLabel?.frame else { return }
        header.textLabel?.frame = CGRect(x: frame.minX + 5, y: frame.minY, width: frame.width, height: frame.height)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.cellType(for: indexPath) {
        case .friend:
            let cell = tableView.dequeueReusableCell(for: indexPath) as FriendCell
            let name = viewModel.titleForRow(at: indexPath)
            cell.viewModel = FriendCell.ViewModel(name: name)
            return cell
        case .link:
            let cell = tableView.dequeueReusableCell(for: indexPath) as LinkCell
            let title = viewModel.titleForRow(at: indexPath)
            cell.viewModel = LinkCell.ViewModel(title: title)
            return cell
        }
    }
}

extension FriendsListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard viewModel.canSelect(indexPath: indexPath) else { return nil }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(indexPath: indexPath)
        processSelection(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        viewModel.didDeselect(indexPath: indexPath)
        processSelection(tableView: tableView, indexPath: indexPath)
    }
    
    private func processSelection(tableView: UITableView, indexPath: IndexPath) {
        switch viewModel.cellType(for: indexPath) {
        case .friend:
            topBar.setText(viewModel.topBarText)
            bottomBarNeedsUpdate()
        case .link:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
