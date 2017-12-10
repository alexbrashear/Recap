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

typealias PaymentsCreateCustomerResult = Result<String, PaymentsError>
typealias PaymentsCreateCustomerCompletion = (PaymentsCreateCustomerResult) -> Void

typealias PaymentsBuyFilmResult = Result<Void, PaymentsError>
typealias PaymentsBuyFilmCompletion = (PaymentsBuyFilmResult) -> Void

struct PaymentsNotification {
    static let methodSelected = Notification.Name("methodSelected")
    
    static let paymentIconKey = "paymentIcon"
    static let paymentDescriptionKey = "paymentDescription"
}

class PaymentsController {
    
    var paymentIcon: UIView?
    
    private var userController: UserController
    private var mostRecentNonce: String?
    private var environment: Environment = .production
    
    private var hostname: String {
        switch environment {
        case .production:
            return "https://recap-messaging.herokuapp.com/"
        case .debug, .test:
            return "https://recap-messaging-sandbox.herokuapp.com/"
        }
    }
    
    init(userController: UserController) {
        self.userController = userController
    }
    
    /// Creates a drop in controller for braintree payments
    ///
    /// - Parameter completion: completion handler to with controller
    func paymentsDropInController(completion: @escaping PaymentsDropInController) {
        if let customerId = userController.user?.customerId, customerId != "" {
            processCustomer(customerId: customerId, completion: completion); return
        }
        
        createCustomer { [weak self] result in
            switch result {
            case let .success(customerId):
                self?.userController.createCustomer(customerId: customerId) { result in
                    switch result {
                    case let .success(user):
                        self?.processCustomer(customerId: user.customerId!, completion: completion)
                    case .error:
                        completion(nil)
                    }
                }
            case .error:
                completion(nil)
            }
        }
    }
    
    func buyFilm(packs: Int, capacity: Int, completion: @escaping PaymentsBuyFilmCompletion) {
        guard packs > 0, let nonce = mostRecentNonce else { return completion(.error(.unknownFailure)) }
        postNonceToServer(paymentMethodNonce: nonce, numberOfPacks: packs) { [weak self] result in
            switch result {
            case let .error(err):
                completion(.error(err))
            case .success:
                let film = packs * capacity
                self?.userController.buyFilm(capacity: film) { result in
                    switch result {
                    case .success:
                        completion(.success())
                    case .error:
                        completion(.error(.failedToAddFilmInDB))
                    }
                }
            }
        }
    }
    
    private func createPaymentsDropIn(clientToken: String, completion: @escaping PaymentsDropInController) {
        let request =  BTDropInRequest()
        let dropIn = BTDropInController(authorization: clientToken, request: request)
        { [weak self] (controller, result, error) in
            if (error != nil) {
                print(error!.localizedDescription)
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
                NotificationCenter.default.post(name: PaymentsNotification.methodSelected,
                                                object: nil,
                                                userInfo: [PaymentsNotification.paymentIconKey: result.paymentIcon,
                                                           PaymentsNotification.paymentDescriptionKey: description])
            }
            controller.dismiss(animated: true, completion: nil)
        }
        completion(dropIn)
    }
    
    private func processCustomer(customerId: String, completion: @escaping PaymentsDropInController) {
        fetchClientToken(customerId: customerId) { [weak self] result in
            switch result {
            case .success(let clientToken):
                self?.createPaymentsDropIn(clientToken: clientToken, completion: completion)
            case .error:
                completion(nil)
            }
        }
    }
    
    private func fetchClientToken(customerId: String, completion: @escaping PaymentsClientTokenCompletion) {
        // TODO: Switch this URL to your own authenticated API
        let clientTokenURL = NSURL(string: "\(hostname)client_token")!
        let clientTokenRequest = NSMutableURLRequest(url: clientTokenURL as URL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        clientTokenRequest.httpBody = "customerId=\(customerId)".data(using: String.Encoding.utf8)
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
                if let data = data, error == nil {
                    // debugging help
//                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                    print(json!)
                    completion(.success())
                } else {
                    print("Payment Error: \(error!)")
                    completion(.error(.failedToPostNonce))
                }
            }
        }.resume()
    }
    
    private func createCustomer(completion: @escaping PaymentsCreateCustomerCompletion) {
        guard let user = userController.user else { completion(.error(.createCustomerFailed)); return }
        let paymentURL = URL(string: "\(hostname)customer/new-v2")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "firstName=\(user.address.firstName)&lastName=\(user.address.lastName)&email=\(user.username)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            DispatchQueue.main.async {
                guard let data = data,
                    error == nil,
                    let optionalJson = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                    let json = optionalJson
                else {
                    return completion(.error(.createCustomerFailed))
                }
                
                if let customerId = json["result"] as? String {
                    completion(.success(customerId))
                } else {
                    completion(.error(.createCustomerFailed))
                }
            }
        }.resume()
    }
}

enum PaymentsError: AlertableError {
    case unknownFailure
    case failedToPostNonce
    case failedToAddFilmInDB
    case createCustomerFailed
    
    var localizedTitle: String {
        switch self {
        case .unknownFailure:
            return "Something went wrong"
        case .failedToPostNonce:
            return "We couldn't process your payment"
        case .failedToAddFilmInDB:
            return "Your payment went through but there was an error adding the film"
        case .createCustomerFailed:
            return "Something went wrong"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .unknownFailure:
            return "We're really sorry for the trouble! Please try again or contact help@recap-app.com"
        case .failedToPostNonce:
            return "Something went wrong with your payment, please try again or contact help@recap-app.com"
        case .failedToAddFilmInDB:
            return "This is really embarrassing...please contact help@recap-app.com so we can fix this for you as fast as possible."
        case .createCustomerFailed:
            return "Check that you have a good internet connection and are using the latest version of the app. Please try again or contact us at help@recap-app.com"
        }
    }
}
