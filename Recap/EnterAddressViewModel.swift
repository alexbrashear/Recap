//
//  EnterAddressViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 4/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class EnterAddressViewModel: EnterAddressViewModelProtocol {
    var nextAction: NextAction
    
    init(nextAction: @escaping NextAction) {
        self.nextAction = nextAction
    }
}
