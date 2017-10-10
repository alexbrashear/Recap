//
//  PaymentsController.swift
//  Recap
//
//  Created by Alex Brashear on 10/9/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation
import Braintree
import BraintreeDropIn

typealias PaymentsClientTokenResult = Result<String, PaymentsError>
typealias PaymentsClientTokenCompletion = (PaymentsClientTokenResult) -> Void

typealias PaymentsPostNonceResult = Result<Void, PaymentsError>
typealias PaymentsPostNonceCompletion = (PaymentsPostNonceResult) -> Void

typealias PaymentsDropInController = (BTDropInController?) -> Void

typealias PaymentsCreateCustomerCompletion = () -> Void

class PaymentsController {
    
    var customerId: String? {
        return persistanceManager.customerId
    }
    
    private var persistanceManager: PersistanceManager
    
    private let hostname = "https://recap-messaging.herokuapp.com/"
    private let __debugHost = "http://localhost:3000/"
    
    init(persistanceManager: PersistanceManager) {
        self.persistanceManager = persistanceManager
    }
    
    func paymentsDropInController(completion: @escaping PaymentsDropInController) {
        fetchClientToken { [weak self] result in
            switch result {
            case .success(let clientToken):
                self?.createPaymentsDropIn(clientToken: clientToken, completion: completion)
            case .error:
                completion(nil)
            }
        }
    }
    
    func createPaymentsDropIn(clientToken: String, completion: @escaping PaymentsDropInController) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientToken, request: request)
        { [weak self] (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                if customerId == nil, let nonce = result.paymentMethod?.nonce {
                    self?.createCustomer(paymentMethodNonce: nonce) { _ in }
                }
            }
            controller.dismiss(animated: true, completion: nil)
        }
        completion(dropIn)
    }
    
    private func fetchClientToken(completion: @escaping PaymentsClientTokenCompletion) {
        // TODO: Switch this URL to your own authenticated API
        let clientTokenURL = NSURL(string: "\(__debugHost)client_token")!
        let clientTokenRequest = NSMutableURLRequest(url: clientTokenURL as URL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        if let customerId = self.customerId {
            clientTokenRequest.httpBody = "customerId=\(customerId)".data(using: String.Encoding.utf8)
        }
        clientTokenRequest.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: clientTokenRequest as URLRequest) { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return completion(.error(.unknownFailure))
            }
            
            if let clientToken = String(data: data, encoding: String.Encoding.utf8) {
                completion(.success(clientToken))
            } else {
                completion(.error(.unknownFailure))
            }
        }.resume()
    }
    
    func postNonceToServer(paymentMethodNonce: String, numberOfPacks: Int, completion: @escaping PaymentsPostNonceCompletion) {
        let paymentURL = URL(string: "\(__debugHost)checkouts")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)&number_of_packs=\(numberOfPacks)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.error(.unknownFailure))
                } else {
                    completion(.success())
                }
            }
        }.resume()
    }
    
    func createCustomer(paymentMethodNonce: String, completion: @escaping PaymentsCreateCustomerCompletion) {
        guard customerId == nil else { return completion() }
        let paymentURL = URL(string: "\(__debugHost)customer/new")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) -> Void in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    return completion()
                }
                
                if let customerId = String(data: data, encoding: String.Encoding.utf8) {
                    self?.persistanceManager.customerId = customerId
                }
                completion()
            }
        }.resume()
    }
}

enum PaymentsError: Error {
    case unknownFailure
}
