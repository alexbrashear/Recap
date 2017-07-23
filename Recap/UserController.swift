//
//  UserController.swift
//  Recap
//
//  Created by Alex Brashear on 4/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Apollo

typealias UserCallback = (Result<CompleteUser, UserError>) -> ()

class UserController {
    
    let graphql: ApolloClient
    
    var user: User? {
        guard let completeAddress = completeUser?.address?.fragments.completeAddress else { return nil }
        return User(address: Address(completeAddress: completeAddress))
    }
    
    var completeUser: CompleteUser?
   
    init(graphql: ApolloClient) {
        self.graphql = graphql
    }
    
    func setNewUser(address: Address) {
        let user = User(address: address)
        
        let collection = DatabaseController.Collection.user.rawValue
        let connection = DatabaseController.sharedInstance.newWritingConnection()
        connection.readWrite { transaction in
            transaction.setObject([user], forKey: "user", inCollection: collection)
        }
        
//        self.user = user
    }
    
    func loginUser(email: String, password: String, callback: @escaping UserCallback) {
        let loginUserMutation = LoginUserMutation(input: LoginUserInput(username: email, password: password))
        graphql.perform(mutation: loginUserMutation, queue: .main) { [weak self] result, error in
            guard let user = result?.data?.loginUser?.user?.fragments.completeUser, error == nil else {
                callback(.error(.loginFailed))
                return
            }
            self?.completeUser = user
            callback(.success(user))
        }
    }
    
    func signupUser(address: Address, email: String, password: String, callback: @escaping UserCallback) {
        ///
        /// TODO: CHEcK FOR VALID EMAIL
        ///
        
        let createAddressInput = CreateAddressInput(city: address.city, secondaryLine: address.line2, name: address.name, primaryLine: address.line1, zipCode: address.zip, state: address.state)
        let createUserInput = CreateUserInput(username: email, address: createAddressInput, password: password)
        let mut = SignupUserMutation(user: createUserInput)
        
        graphql.perform(mutation: mut, queue: .main) { [weak self] result, error in
            guard let user = result?.data?.createUser?.changedUser?.fragments.completeUser, error == nil else {
                callback(.error(.signupFailed))
                return
            }
            self?.completeUser = user
            callback(.success(user))
        }
        
    }
}

enum UserError: Error {
    case loginFailed
    case signupFailed
    
    var localizedTitle: String {
        return "test"
    }
    
    var localizedDescription: String {
        return "test"
    }
    
    var alert: UIAlertController {
        return UIAlertController.okAlert(title: localizedTitle, message: localizedDescription)
    }
}
