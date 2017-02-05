//
//  Persister.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

typealias SaveAddressResult = Result<Void, AddressError>
typealias SaveAddressCompletion = (SaveAddressResult) -> Void

class Persister {
    private static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    private static let AddressArchiveURL = DocumentsDirectory.appendingPathComponent("addresses")
    
    func save(address: Address) -> Bool {
        guard var addresses = loadAddresses() else { return false }
        addresses.insert(address, at: 0)
        return save(addresses: addresses)
    }
    
    func loadAddresses() -> [Address]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Persister.AddressArchiveURL.path) as? [Address]
    }
    
    func save(addresses: [Address]) -> Bool {
        return NSKeyedArchiver.archiveRootObject(addresses, toFile: Persister.AddressArchiveURL.path)
    }
}
