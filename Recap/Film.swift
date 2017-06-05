//
//  Film.swift
//  Recap
//
//  Created by Alex Brashear on 5/24/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class Film: NSObject, NSCoding {
    var photos = [Photo]()
    var capacity: Int
    var dateOfPurchase: Date
    
    convenience init(capacity: Int) {
        self.init(capacity: capacity, photos: [], dateOfPurchase: Date())
    }
    
    /// Should only be used for decoding object
    ///
    /// NOT FOR PUBLIC USE
    private init(capacity: Int, photos: [Photo], dateOfPurchase: Date) {
        self.capacity = capacity
        self.photos = photos
        self.dateOfPurchase = dateOfPurchase
    }
    
    var isEmpty: Bool {
        return photos.isEmpty
    }
    
    var remainingPhotos: Int {
        return capacity - photos.count
    }
    
    var canAddPhoto: Bool {
        return photos.count < 5
    }
    
    var photosSent: Int {
        return photos.count
    }
    
    func addPhoto(_ photo: Photo) {
        if remainingPhotos > 0 {
            photos.append(photo)
        }
    }
    
    // MARK: - NSCoding
    
    enum Keys: String {
        case capacity
        case photos
        case dateOfPurchase
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let photos = aDecoder.decodeObject(forKey: Keys.photos.rawValue) as? [Photo],
            let dateOfPurchase = aDecoder.decodeObject(forKey: Keys.dateOfPurchase.rawValue) as? Date else {
                assertionFailure("unable to decode Film")
                return nil
        }
        
        let capacity = aDecoder.decodeInteger(forKey: Keys.capacity.rawValue)
        
        
        self.init(capacity: capacity, photos: photos, dateOfPurchase: dateOfPurchase)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(capacity, forKey: Keys.capacity.rawValue)
        aCoder.encode(photos, forKey: Keys.photos.rawValue)
        aCoder.encode(dateOfPurchase, forKey: Keys.dateOfPurchase.rawValue)
    }
}
