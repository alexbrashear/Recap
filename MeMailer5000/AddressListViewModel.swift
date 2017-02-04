//
//  AddressListProvider.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class AddressListViewModel: AddressListViewModelProtocol {
    var numberOfSections: Int = 0
    
    func numberOfRows(in section: Int) -> Int {
        return 0
    }
    
    func title(for indexPath: IndexPath) -> String {
        return ""
    }
    
    func subtitle(for indexPath: IndexPath) -> String {
        return ""
    }
}
