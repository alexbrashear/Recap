//
//  NetworkClient.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/12/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

typealias RequestCompletion = (_ json: [String:AnyObject]?) -> Void

enum Environment {
    case test
    case debug
    case production
    
}

class NetworkClient {
    
    private let environment: Environment
    
    init() {
        self.environment = .debug
    }
    
    var authorization: String {
        let username = environment.authorizationValue
        let password = ""
        let loginData = "\(username):\(password)".data(using: .utf8)
        return loginData?.base64EncodedString() ?? ""
    }
    
    func POST(url: URL, data: Data?, completion: @escaping RequestCompletion) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Basic \(authorization)", forHTTPHeaderField: "Authorization")
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return completion(nil) }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                completion(json)
            } catch {
                completion(nil)
            }
        }.resume()
    }
}
