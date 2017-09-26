//
//  FriendsListController.swift
//  Recap
//
//  Created by Alex Brashear on 9/11/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class FriendsListController: UIViewController {
    
    var tableView: UITableView!
    var bottomBar = UIView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bottomBar.backgroundColor = .red
        tableView = UITableView(frame: .zero)
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(bottomBar)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor).isActive = true
        
        tableView.register(cellType: FriendCell.self)
        tableView.allowsMultipleSelection = true
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension FriendsListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as FriendCell
        return cell
    }
}

extension FriendsListController: UITableViewDelegate {}
