//
//  AddressListProvider.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import PKHUD

protocol AddressListProviderProtocol {
    func loadAddresses() -> [Address]
}

class AddressListViewModel: AddressListViewModelProtocol {
    
    private let postcardSender = PostcardSender()
    
    private var dataChangedBlock: (() -> Void)?
    
    private let addressListProvider: AddressListProviderProtocol
    
    var numberOfSections: Int = 1
    
    var selectedAddressCompletionBlock: SelectedAddressCompletionBlock
    
    private var addresses: [Address]
    
    init(addresses: [Address], addressListProvider: AddressListProviderProtocol, selectedAddressCompletionBlock: @escaping SelectedAddressCompletionBlock) {
        self.addresses = addresses
        self.addressListProvider = addressListProvider
        self.selectedAddressCompletionBlock = selectedAddressCompletionBlock
        
        NotificationCenter.default.addObserver(self, selector: #selector(yapDatabaseModified), name: NSNotification.Name.YapDatabaseModified, object: DatabaseController.sharedInstance.yapDatabase)
    }
    
    @objc private func yapDatabaseModified(notification: Notification) {
        addresses = addressListProvider.loadAddresses()
        dataChangedBlock?()
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
    
    func observeDataChanges(withBlock block: (() -> Void)?) {
        dataChangedBlock = block
    }
    
    private func displayableSubtitle(for address: Address) -> String {
        let line2 = address.line2 == "" ? "" : " \(address.line2)"
        return "\(address.line1)\(line2), \(address.city), \(address.state)."
    }
}
