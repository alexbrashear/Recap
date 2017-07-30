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
        guard let completeAddress = completeUser.address?.fragments.completeAddress,
              let film = completeUser.film?.fragments.photosCount,
              let usedPhotos = film.photos?.aggregations?.count else { return nil }
        let remainingPhotos = film.capacity - usedPhotos
        let address = Address(completeAddress: completeAddress)
        self.init(id: completeUser.id, filmId: film.id, username: completeUser.username, address: address, remainingPhotos: remainingPhotos)
    }
}
