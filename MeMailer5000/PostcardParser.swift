//
//  PostcardParser.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/20/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

struct PostcardParser {
    func parse(json: [String: AnyObject]) -> (Postcard?, PostcardError?) {
        print(json)
        guard let to = parseAddress(fromJson: json),
              let thumbnails = parseThumbnails(fromJson: json),
              let id = json[Postcard.Keys.id.rawValue] as? String,
              let expectedDeliveryDate = json[Postcard.Keys.expectedDeliveryDate.rawValue] as? String else { return (nil, .parsingFailure) }
        return (Postcard(id: id, expectedDeliveryDate: expectedDeliveryDate, imageThumbnails: thumbnails[0], messageThumbnails: thumbnails[1], to: to), nil)
    }
    
    private func parseAddress(fromJson json: [String: AnyObject]) -> Address? {
        print(json)
        let addressParser = AddressParser()
        guard let toJson = json[Postcard.Keys.to.rawValue] as? [String: AnyObject] else { return nil }
        print(toJson)
        guard let name = toJson[Address.Keys.name.rawValue] as? String else { return nil }
        let (to, _) = addressParser.parse(json: toJson, name: name)
        return to
    }
    
    private func parseThumbnails(fromJson json: [String: AnyObject]) -> [Thumbnails]? {
        print(json)
        guard let thumbnailArray = json["thumbnails"] as? [[String: AnyObject]] else { return nil }
        if thumbnailArray.count != 2 { return nil }
        guard let front = parseThumbnailObject(thumbnail: thumbnailArray[0]),
              let back = parseThumbnailObject(thumbnail: thumbnailArray[1]) else { return nil }
        return [front, back]
    }
    
    private func parseThumbnailObject(thumbnail: [String: AnyObject]) -> Thumbnails? {
        print(thumbnail)
        guard let smallString = thumbnail[Thumbnails.Keys.small.rawValue] as? String,
              let mediumString = thumbnail[Thumbnails.Keys.medium.rawValue] as? String,
              let largeString = thumbnail[Thumbnails.Keys.large.rawValue] as? String else { return nil }
        guard let small = URL(string: smallString),
              let medium = URL(string: mediumString),
              let large = URL(string: largeString) else { return nil }
        return Thumbnails(small: small, medium: medium, large: large)
    }
    
    
}
