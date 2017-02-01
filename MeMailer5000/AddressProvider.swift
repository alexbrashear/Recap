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
    
    func verify(name: String, line1: String, line2: String, city: String, state: String, zip: String) {
        guard let verifyURL = URL(string: verifyURLString) else { return }
        var verifyRequest = URLRequest(url: verifyURL)
        verifyRequest.httpMethod = "POST"
        verifyRequest.addValue("Basic \(testCredentials)", forHTTPHeaderField: "Authorization")
        verifyRequest.httpBody = formatHTTPBody(withLine1: line1, line2: line2, city: city, state: state, zip: zip)
        URLSession.shared.dataTask(with: verifyRequest) { (data, response, error) in
            guard let data = data, let response = response else {
                print("\(error)")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                self.parser.parse(json: json)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    private func formatHTTPBody(withLine1 line1: String, line2: String, city: String, state: String, zip: String) -> Data? {
        return "address_line1=\(line1)&address_line2=\(line2)&address_city=\(city)&address_state=\(state)&address_zip=\(zip)".data(using: .utf8)
    }
}
