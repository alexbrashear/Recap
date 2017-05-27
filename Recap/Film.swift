//
//  Film.swift
//  Recap
//
//  Created by Alex Brashear on 5/24/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class Film: NSObject, NSCoding {
    private var photos = [Photo]()
    var capacity: Int
    
    convenience init(capacity: Int) {
        self.init(capacity: capacity, photos: [])
    }
    
    /// Should only be used for decoding object
    ///
    /// NOT FOR PUBLIC USE
    private init(capacity: Int, photos: [Photo]) {
        self.capacity = capacity
        self.photos = photos
    }
    
    var remainingPhotos: Int {
        return capacity - photos.count
    }
    
    func addPhoto(_ photo: Photo) {
        if remainingPhotos > 0 {
            photos.append(photo)
        }
    }
    
    // MARK: - NSCoding
    
    enum Keys: String {
        case capacity = "capacity"
        case photos = "photos"
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let photos = aDecoder.decodeObject(forKey: Keys.photos.rawValue) as? [Photo] else {
                assertionFailure("unable to decode Film")
                return nil
        }
        
        let capacity = aDecoder.decodeInteger(forKey: Keys.capacity.rawValue)
        
        self.init(capacity: capacity, photos: photos)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(capacity, forKey: Keys.capacity.rawValue)
        aCoder.encode(photos, forKey: Keys.photos.rawValue)
    }
}
