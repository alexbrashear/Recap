//
//  GraphQLInitializers.swift
//  Recap
//
//  Created by Alex Brashear on 7/23/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

extension Address {
    convenience init(completeAddress: CompleteAddress) {
        self.init(id: completeAddress.id, name: completeAddress.name, primaryLine: completeAddress.primaryLine, secondaryLine: completeAddress.secondaryLine ?? "", city: completeAddress.city, state: completeAddress.state, zip: completeAddress.zipCode)
    }
}

extension User {
    convenience init?(completeUser: CompleteUser) {
        guard let completeAddress = completeUser.address?.fragments.completeAddress else { return nil }
        let address = Address(completeAddress: completeAddress)
        self.init(id: completeUser.id, username: completeUser.username, address: address, remainingPhotos: completeUser.remainingPhotos, inviteCode: completeUser.inviteCode)
    }
}

extension Photo {
    init?(completePhoto: CompletePhoto) {
        guard let imageURL = URL(string: completePhoto.imageUrl),
            let edges = completePhoto.recipients?.edges else { return nil }
        var recipients = [Address]()
        for edge in edges {
            guard let completeAddress = edge?.node.fragments.completeAddress else { continue }
            recipients.append(Address(completeAddress: completeAddress))
        }
        self.init(id: completePhoto.id, imageURL: imageURL, recipients: recipients)
    }
}
