//
//  AddressProvider.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 1/31/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation


class AddressProvider {
    private let parser = AddressParser()
    private let verifyURLString = "https://api.lob.com/v1/verify"
    private var testCredentials: String {
        let username = "test_3f5d20f0882cd26b96fbabe1a4161a5285f"
        let password = ""
        let loginData = "\(username):\(password)".data(using: .utf8)
        return loginData?.base64EncodedString() ?? ""
    }
    
    func verify(name: String, line1: String, line2: String, city: String, state: String, zip: String, completion: @escaping AddressVerificationCompletion) {
        guard let verifyURL = URL(string: verifyURLString) else { return }
        var verifyRequest = URLRequest(url: verifyURL)
        verifyRequest.httpMethod = "POST"
        verifyRequest.addValue("Basic \(testCredentials)", forHTTPHeaderField: "Authorization")
        verifyRequest.httpBody = formatHTTPBody(withLine1: line1, line2: line2, city: city, state: state, zip: zip)
        URLSession.shared.dataTask(with: verifyRequest) { [weak self] (data, response, error) in
            guard let data = data else { return completion(nil, .unknownFailure) }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                if let json = json {
                    let (address, error) = self?.parser.parse(json: json, name: name) ?? (nil, .unknownFailure)
                    completion(address, error)
                } else {
                    completion(nil, .unknownFailure)
                }
            } catch {
                completion(nil, .unknownFailure)
            }
        }.resume()
    }
    
    private func formatHTTPBody(withLine1 line1: String, line2: String, city: String, state: String, zip: String) -> Data? {
        return "address_line1=\(line1)&address_line2=\(line2)&address_city=\(city)&address_state=\(state)&address_zip=r\(zip)".data(using: .utf8)
    }
}
