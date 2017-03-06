//
//  SentPostcardsViewModel.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 3/2/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class SentPostcardsViewModel: SentPostcardsViewModelProtocol {
    var numberOfSections: Int = 1
    
    let sentPostcards: [Postcard]
    
    init(sentPostcards: [Postcard]) {
        self.sentPostcards = sentPostcards.sorted { $0.dateCreated.compare($1.dateCreated) == .orderedDescending }
    }
    
    func numberOfRows(in section: Int) -> Int {
        return sentPostcards.count
    }
    
    func cellConfiguration(for indexPath: IndexPath) -> SentPostcardCellConfiguration {
        guard indexPath.row >= 0 && indexPath.row < sentPostcards.count else { fatalError() }
        let sentPostcard = sentPostcards[indexPath.row]
        return SentPostcardCellConfiguration(name: sentPostcard.to.name, expectedDelivery: "replace me please", thumbnailURL: sentPostcard.imageThumbnails.small)
    }
}
