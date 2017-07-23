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
        self.init(id: "", name: completeAddress.name, line1: completeAddress.primaryLine, line2: completeAddress.secondaryLine ?? "", city: completeAddress.city, state: completeAddress.state, zip: completeAddress.zipCode)
    }
}
