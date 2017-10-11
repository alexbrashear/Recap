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
        self.init(id: completeAddress.id, name: completeAddress.name, line1: completeAddress.primaryLine, line2: completeAddress.secondaryLine ?? "", city: completeAddress.city, state: completeAddress.state, zip: completeAddress.zipCode)
    }
}

extension User {
    convenience init?(completeUser: CompleteUser) {
        guard let completeAddress = completeUser.address?.fragments.completeAddress else { return nil }
        let address = Address(completeAddress: completeAddress)
        self.init(id: completeUser.id, username: completeUser.username, address: address, remainingPhotos: completeUser.remainingPhotos)
    }
}

extension Photo {
    init?(completePhoto: CompletePhoto) {
        guard let imageURL = URL(string: completePhoto.imageUrl) else { return nil }
        self.init(imageURL: imageURL)
    }
}
