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

typealias PaymentsBuyFilmResult = Result<Void, PaymentsError>
typealias PaymentsBuyFilmCompletion = (PaymentsBuyFilmResult) -> Void

struct PaymentsNotification {
    static let methodSelected = Notification.Name("methodSelected")
    
    static let paymentIconKey = "paymentIcon"
    static let paymentDescriptionKey = "paymentDescription"
}

class PaymentsController {
    
    var customerId: String? {
        return persistanceManager.customerId
    }
    
    var paymentIcon: UIView?
    
    private var persistanceManager: PersistanceManager
    private var userController: UserController
    private var mostRecentNonce: String?
    private var environment: Environment = .production
    
    private var hostname: String {
        switch environment {
        case .production:
            return "https://recap-messaging.herokuapp.com/"
        case .debug, .test:
            return "http://localhost:3000/"
        }
    }
    
    init(persistanceManager: PersistanceManager, userController: UserController) {
        self.persistanceManager = persistanceManager
        self.userController = userController
    }
    
    /// Creates a drop in controller for braintree payments
    ///
    /// - Parameter completion: completion handler to with controller
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
    
    func buyFilm(packs: Int, capacity: Int, completion: @escaping PaymentsBuyFilmCompletion) {
        guard packs > 0, let nonce = mostRecentNonce else { return completion(.error(.unknownFailure)) }
        postNonceToServer(paymentMethodNonce: nonce, numberOfPacks: packs) { [weak self] result in
            let film = packs * capacity
            self?.userController.buyFilm(capacity: film) { result in
                switch result {
                case .success(let user):
                    completion(.success())
                case .error(let err):
                    completion(.error(.unknownFailure))
                }
            }
        }
    }
    
    private func createPaymentsDropIn(clientToken: String, completion: @escaping PaymentsDropInController) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientToken, request: request)
        { [weak self] (controller, result, error) in
            if (error != nil) {
                print("ERROR")
            } else if (result?.isCancelled == true) {
                print("CANCELLED")
            } else if let result = result {
                self?.mostRecentNonce = result.paymentMethod?.nonce
                var description: String
                if let venmoResult = result.paymentMethod as? BTVenmoAccountNonce {
                    description = venmoResult.username ?? ""
                } else {
                    description = result.paymentDescription
                }
                self?.paymentIcon = result.paymentIcon
                if self?.customerId == nil, let nonce = result.paymentMethod?.nonce {
                    self?.createCustomer(paymentMethodNonce: nonce) { _ in }
                }
                NotificationCenter.default.post(name: PaymentsNotification.methodSelected,
                                                object: nil,
                                                userInfo: [PaymentsNotification.paymentIconKey: result.paymentIcon,
                                                           PaymentsNotification.paymentDescriptionKey: description])
            }
            controller.dismiss(animated: true, completion: nil)
        }
        completion(dropIn)
    }
    
    private func fetchClientToken(completion: @escaping PaymentsClientTokenCompletion) {
        // TODO: Switch this URL to your own authenticated API
        let clientTokenURL = NSURL(string: "\(hostname)client_token")!
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
    
    private func postNonceToServer(paymentMethodNonce: String, numberOfPacks: Int, completion: @escaping PaymentsPostNonceCompletion) {
        let paymentURL = URL(string: "\(hostname)checkouts")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)&number_of_packs=\(numberOfPacks)&device_data=\(PPDataCollector.collectPayPalDeviceData())".data(using: String.Encoding.utf8)
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
    
    private func createCustomer(paymentMethodNonce: String, completion: @escaping PaymentsCreateCustomerCompletion) {
        guard customerId == nil else { return completion() }
        let paymentURL = URL(string: "\(hostname)customer/new")!
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
