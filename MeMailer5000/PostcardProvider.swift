//
//  PostcardProvider.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/1/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

class PostcardProvider {
    private let parser = PostcardParser()
    private let postcardURLString = "https://api.lob.com/v1/postcards"
    private var testCredentials: String {
        let username = "test_3f5d20f0882cd26b96fbabe1a4161a5285f"
        let password = ""
        let loginData = "\(username):\(password)".data(using: .utf8)
        return loginData?.base64EncodedString() ?? ""
    }
    
    func postcard(to: Address, from: Address?, front: String, message: String, size: String = "4x6") {
        guard let postcardURL = URL(string: postcardURLString) else { return }
        var postcardRequest = URLRequest(url: postcardURL)
        postcardRequest.httpMethod = "POST"
        postcardRequest.addValue("Basic \(testCredentials)", forHTTPHeaderField: "Authorization")
        postcardRequest.httpBody = formatHTTPBody(to: to, from: from, front: front, message: message, size: size)
        URLSession.shared.dataTask(with: postcardRequest) { (data, _, error) in
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    func formatHTTPBody(to: Address, from: Address?, front: String, message: String, size: String = "4x6") -> Data? {
        var unwrappedFrom = ""
        if let from = from {
            unwrappedFrom = "\(from.bodyString(withParent: "from"))&"
        }
        return "\(to.bodyString(withParent: "to"))&\(unwrappedFrom)front=\(front)&message=\(message)&size=\(size)".data(using: .utf8)
        
    }
}
