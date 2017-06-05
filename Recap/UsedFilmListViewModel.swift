//
//  UsedFilmListViewModel.swift
//  Recap
//
//  Created by Alex Brashear on 5/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class UsedFilmListViewModel: UsedFilmListViewModelProtocol {
    var rowTapHandler: FilmRowTapHandler
    
    init(rowTapHandler: @escaping FilmRowTapHandler) {
        self.rowTapHandler = rowTapHandler
    }
}
