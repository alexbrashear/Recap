//
//  FilmController.swift
//  Recap
//
//  Created by Alex Brashear on 5/29/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class FilmController {
    
    private enum Keys: String {
        case current
        case past
    }
    
    var currentFilm: Film?
    
    init() {
        self.currentFilm = loadCurrentFilm()
    }
    
    func canTakePhoto() -> Bool {
        return currentFilm?.canAddPhoto ?? false
    }
    
    func useFilmSlot(_ photo: Photo) -> Int {
        currentFilm?.addPhoto(photo)
        
        if !canTakePhoto() {
            // add film to past film
            // nil out the current film
        }
        
        updateCurrentFilmInStore()
        return currentFilm?.remainingPhotos ?? 0
    }
    
    private func loadCurrentFilm() -> Film? {
        var film: Film?
        
        let collection = DatabaseController.Collection.film.rawValue
        let connection = DatabaseController.sharedInstance.newReadingConnection()
        connection.read { transaction in
            let filmArr = transaction.object(forKey: Keys.current.rawValue, inCollection: collection) as? [Film]
            film = filmArr?.isEmpty ?? true ? nil : filmArr?.first
        }
        
        return film
    }
    
    private func updateCurrentFilmInStore() {
        let collection = DatabaseController.Collection.film.rawValue
        let connection = DatabaseController.sharedInstance.newWritingConnection()
        connection.readWrite { transaction in
            transaction.replace(self.currentFilm, forKey: Keys.current.rawValue, inCollection: collection)
        }
    }
}
