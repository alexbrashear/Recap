//
//  ApolloClient+Token.swift
//  Recap
//
//  Created by Alex Brashear on 7/23/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation
import Apollo

class ApolloWrapper {
    var client: ApolloClient
    
    init(token: String? = nil) {
        if let token = token {
            let client = ApolloWrapper.newClient(forToken: token)
            self.client = client
        } else {
            self.client = ApolloClient(url: URL(string: "https://us-west-2.api.scaphold.io/graphql/recap")!)
        }
    }
    
    private static func newClient(forToken token: String) -> ApolloClient {
        let configuration = URLSessionConfiguration.default
        // Add additional headers as needed
        configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
        
        let url = URL(string: "https://us-west-2.api.scaphold.io/graphql/recap")!
        
        return ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
    }
    
    func setToken(_ token: String) {
        client = ApolloWrapper.newClient(forToken: token)
    }
}
