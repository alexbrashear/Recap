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
    
    var graphql: ApolloWrapper
    
    var user: User? {
        guard let completeAddress = completeUser?.address?.fragments.completeAddress else { return nil }
        return User(address: Address(completeAddress: completeAddress))
    }
    
    var completeUser: CompleteUser?
   
    init(graphql: ApolloWrapper) {
        self.graphql = graphql
    }
    
    func updateAddress(newAddress: Address, callback: @escaping UserCallback) {
        guard let id = user?.address.id, let userId = completeUser?.id else { return }
        let input = UpdateAddressInput(id: id, userId: userId, city: newAddress.city, secondaryLine: newAddress.line2, name: newAddress.name, primaryLine: newAddress.line1, zipCode: newAddress.zip, state: newAddress.state, clientMutationId: nil)
        let mut = UpdateAddressMutation(input: input)
        graphql.client.perform(mutation: mut) { [weak self] result, error in
            guard let updatedUser = result?.data?.updateAddress?.changedAddress?.user?.fragments.completeUser, error == nil else {
                callback(.error(UserError.updateAddressFailed)); return;
            }
            self?.completeUser = updatedUser
            callback(.success(updatedUser))
        }
    }
    
    func loginUser(email: String, password: String, callback: @escaping UserCallback) {
        let loginUserMutation = LoginUserMutation(input: LoginUserInput(username: email, password: password))
        graphql.client.perform(mutation: loginUserMutation, queue: .main) { [weak self] result, error in
            guard let user = result?.data?.loginUser?.user?.fragments.completeUser,
                let token = result?.data?.loginUser?.token,
                error == nil else {
                callback(.error(.loginFailed))
                return
            }
            self?.graphql.setToken(token)
            self?.completeUser = user
            callback(.success(user))
        }
    }
    
    func signupUser(address: Address, email: String, password: String, callback: @escaping UserCallback) {
        ///
        /// TODO: CHEcK FOR VALID EMAIL
        ///
        
        let createAddressInput = CreateAddressInput(city: address.city, secondaryLine: address.line2, name: address.name, primaryLine: address.line1, zipCode: address.zip, state: address.state)
        let createUserInput = CreateUserInput(remainingPhotos: 2, username: email, address: createAddressInput, password: password)
        let mut = SignupUserMutation(user: createUserInput)
        
        graphql.client.perform(mutation: mut, queue: .main) { [weak self] result, error in
            guard let user = result?.data?.createUser?.changedUser?.fragments.completeUser,
                let token = result?.data?.createUser?.token,
                error == nil else {
                callback(.error(.signupFailed))
                return
            }
            self?.graphql.setToken(token)
            self?.completeUser = user
            callback(.success(user))
        }
        
    }
}

enum UserError: Error {
    case loginFailed
    case signupFailed
    case updateAddressFailed
    
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
