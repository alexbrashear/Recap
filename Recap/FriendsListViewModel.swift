//
//  FriendsListViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 9/27/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class FriendsListViewModel: FriendsListViewModelProtocol {
    
    private var selected = [String]()
    private var recapsRemaining = 5
    
    var data: [String] = ["alex", "dave","mo","ben","david","blake","caro",
                          "sam","will","teddy","tim","fabrizio","geranio","ballard",
                          "max","steph","juan","jungles","renato","johnny","will",
                          "renyao","dave kim","nana","pap","dan","doug","mom"]
    
    var topBarTapHandler: () -> Void

    init(topBarTapHandler: @escaping () -> Void) {
        self.topBarTapHandler = topBarTapHandler
    }
    
    var shouldShowBottomBar: Bool {
        return !selected.isEmpty
    }
    
    var bottomBarText: String {
        guard shouldShowBottomBar else { return "" }
        var text = ""
        _ = selected.map {
            text = "\(text) \($0),"
        }
        return text.substring(to: text.index(before: text.endIndex))
    }
    
    var topBarText: String {
        let remaining = recapsRemaining - selected.count
        if remaining == 0 {
            return "0 RECAPS LEFT - TAP TO GET MORE"
        } else if remaining == 1 {
            return "1 RECAP LEFT"
        } else {
            return "\(remaining) RECAPS LEFT"
        }
    }
    
    // mark - UITableViewDataSource
    
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfRows(in section: Int) -> Int {
        return data.count
    }
    
    func titleForRow(at indexPath: IndexPath) -> String {
        return data[indexPath.row]
    }
    
    // mark - UITableViewDelegate
    
    var canSelect: Bool {
        return selected.count < recapsRemaining
    }
    
    func didSelect(indexPath: IndexPath) {
        selected.insert(data[indexPath.row], at: 0)
    }
    
    func didDeselect(indexPath: IndexPath) {
        guard let index = selected.index(of: data[indexPath.row]) else { return }
        selected.remove(at: index)
    }
}
