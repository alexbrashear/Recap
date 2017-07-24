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
    
    init(client: ApolloClient) {
        self.client = client
    }
    
    func setToken(_ token: String) {
        let configuration = URLSessionConfiguration.default
        // Add additional headers as needed
        configuration.httpAdditionalHeaders = ["Authorization": "Bearer \(token)"]
        
        let url = URL(string: "https://us-west-2.api.scaphold.io/graphql/recap")!
        
        client = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
    }
}
