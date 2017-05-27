//
//  UsedFilmListViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 5/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class UsedFilmListViewModel: UsedFilmListViewModelProtocol {
    var rowTapHandler: () -> Void
    
    init(rowTapHandler: @escaping () -> Void) {
        self.rowTapHandler = rowTapHandler
    }
}
