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
    var bottomBar = FriendsListBottomBar(frame: .zero)
    var bottomBarHeight: NSLayoutConstraint?
    
    var data: [String] = ["alex", "dave","mo","ben","david","blake","caro",
                          "sam","will","teddy","tim","fabrizio","geranio","ballard",
                          "max","steph","juan","jungles","renato","johnny","will",
                          "renyao","dave kim","nana","pap","dan","doug","mom"]
    
    var selected = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        guard !selected.isEmpty else {
            return animateBottomBarToHeight(height: 0)
        }
        
        var text = ""
        _ = selected.map {
            text = "\(text) \($0),"
        }
        let truncated = text.substring(to: text.index(before: text.endIndex))
        bottomBar.setText(truncated)
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as FriendCell
        let name = data[indexPath.row]
        cell.viewModel = FriendCell.ViewModel(name: name)
        return cell
    }
}

extension FriendsListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected.insert(data[indexPath.row], at: 0)
        bottomBarNeedsUpdate()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let index = selected.index(of: data[indexPath.row]) else { return }
        selected.remove(at: index)
        bottomBarNeedsUpdate()
    }
}
