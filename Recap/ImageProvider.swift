//
//  ImageProvider.swift
//  Recap
//
//  Created by Alex Brashear on 8/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit

typealias ImageCallback = (Result<UIImage, ImageError>) -> ()

class ImageProvider {
    
    private var cache = [URL: UIImage]()
    
    let urlSession: URLSession = {
       return URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    }()
    
    func fetchImage(forUrl url: URL, callback: @escaping ImageCallback) {
        if let image = cache[url] {
            callback(.success(image)); return
        }
        
        urlSession.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data,
                let image = UIImage(data: data) else {
                    callback(.error(.unknownFailure)); return
            }
            self?.cache[url] = image
            callback(.success(image))
        }.resume()
    }
}

enum ImageError: Error {
    case unknownFailure
    
    var localizedTitle: String {
        return "Test"
    }
    
    var localizedDescription: String {
        return "image fail"
    }
}
