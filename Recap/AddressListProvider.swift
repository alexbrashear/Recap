//
//  AddressListProvider.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 3/6/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class AddressListProvider: AddressListProviderProtocol {
    
    let databaseConnection = DatabaseController.sharedInstance.newWritingConnection()

    func loadAddresses() -> [Address] {
        databaseConnection.beginLongLivedReadTransaction()
        var addresses: [Address]?
        databaseConnection.read { transaction in
            addresses = transaction.object(forKey: "addresses", inCollection: "addresses") as? [Address]
        }
        return addresses ?? []
    }
}
