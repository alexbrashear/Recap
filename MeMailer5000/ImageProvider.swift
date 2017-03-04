//
//  ImageProvider.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 3/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

class ImageProvider: ImageProviderProtocol {
    
    private let networkClient = NetworkClient()
    
    var imageCache: [URL: UIImage] = [:]
    
    func hasItemInCache(itemURL: URL) -> Bool {
        return imageCache[itemURL] != nil
    }
    
    func cachedImage(for url: URL) -> UIImage? {
        return imageCache[url]
    }
    
    func fetchImage(for url: URL, completion: @escaping ImageFetchCompletion) {
        networkClient.GET(url: url) { [weak self] data in
            guard let data = data else { return completion(nil) }
            let image = UIImage(data: data)
            self?.imageCache[url] = image
            completion(image)
        }
    }
}
