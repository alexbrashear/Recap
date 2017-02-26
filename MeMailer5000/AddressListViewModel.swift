//
//  AddressListProvider.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import PKHUD

class AddressListViewModel: AddressListViewModelProtocol {
    
    let postcardSender = PostcardSender()
    
    var numberOfSections: Int = 1
    
    private let addresses: [Address]
    
    init(addresses: [Address]) {
        self.addresses = addresses
    }
    
    func numberOfRows(in section: Int) -> Int {
        return addresses.count
    }
    
    func title(for indexPath: IndexPath) -> String {
        guard indexPath.row >= 0 && indexPath.row < addresses.count else { return "" }
        return addresses[indexPath.row].name
    }
    
    func subtitle(for indexPath: IndexPath) -> String {
        guard indexPath.row >= 0 && indexPath.row < addresses.count else { return "" }
        let address = addresses[indexPath.row]
        return displayableSubtitle(for: address)
    }
    
    func didSelectRow(at indexPath: IndexPath, image: UIImage?, completion: @escaping (PostcardError?) -> Void) {
        guard indexPath.row >= 0 && indexPath.row < addresses.count else { return }
        let address = addresses[indexPath.row]
        postcardSender.send(image: image!, to: address) { postcard, error in
            completion(error)
        }
    }
    
    private func displayableSubtitle(for address: Address) -> String {
        let line2 = address.line2 == "" ? "" : " \(address.line2)"
        return "\(address.line1)\(line2), \(address.city), \(address.state)."
    }
}
