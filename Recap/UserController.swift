//
//  UserController.swift
//  Recap
//
//  Created by Alex Brashear on 4/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Apollo
import KeychainAccess

typealias UserCallback = (Result<User, UserError>) -> ()

class UserController {
    
    fileprivate var graphql: ApolloWrapper
    private var store: PersistanceManager
    
    var user: User? {
        didSet {
            store.user = user
        }
    }
    
    init(graphql: ApolloWrapper, persistanceManager: PersistanceManager) {
        self.graphql = graphql
        self.store = persistanceManager
    }
    
    func loadUser() {
        user = store.user
    }
    
    private func setPassword(newPassword: String) {
        store.password = newPassword
    }
    
    private func setToken(newToken: String) {
        graphql.setToken(newToken)
        store.token = newToken
    }
    
    private func userChangedHandler(user: User, password: String, token: String) {
        self.user = user
        setToken(newToken: token)
        setPassword(newPassword: password)
    }
    
    func loginUser(email: String, password: String, callback: @escaping UserCallback) {
        let loginUserMutation = LoginUserMutation(input: LoginUserInput(username: email, password: password))
        graphql.client.perform(mutation: loginUserMutation, queue: .main) { [weak self] result, error in
            guard let completeUser = result?.data?.loginUser?.user?.fragments.completeUser,
                let token = result?.data?.loginUser?.token,
                let user = User(completeUser: completeUser),
                error == nil
            else {
                callback(.error(.loginFailed))
                return
            }
            self?.userChangedHandler(user: user, password: password, token: token)
            callback(.success(user))
        }
    }
    
    func signupUser(address: Address, email: String, password: String, callback: @escaping UserCallback) {
        ///
        /// TODO: CHEcK FOR VALID EMAIL
        ///
        
        let createAddressInput = CreateAddressInput(city: address.city, secondaryLine: address.line2, name: address.name, primaryLine: address.line1, zipCode: address.zip, state: address.state)
        let createFilmInput = CreateFilmInput(capacity: 2)
        let createUserInput = CreateUserInput(username: email, address: createAddressInput, film: createFilmInput, password: password)
        let mut = SignupUserMutation(user: createUserInput)
        
        graphql.client.perform(mutation: mut, queue: .main) { [weak self] result, error in
            guard let completeUser = result?.data?.createUser?.changedUser?.fragments.completeUser,
                let token = result?.data?.createUser?.token,
                let user = User(completeUser: completeUser),
                error == nil
            else {
                callback(.error(.signupFailed))
                return
            }
            self?.userChangedHandler(user: user, password: password, token: token)
            callback(.success(user))
        }
        
    }
}

// MARK: - Mutations

extension UserController {
    func updateAddress(newAddress: Address, callback: @escaping UserCallback) {
        guard let user = self.user else { return }
        let input = UpdateAddressInput(id: user.address.id, userId: user.id, city: newAddress.city, secondaryLine: newAddress.line2, name: newAddress.name, primaryLine: newAddress.line1, zipCode: newAddress.zip, state: newAddress.state, clientMutationId: nil)
        let mut = UpdateAddressMutation(input: input)
        graphql.client.perform(mutation: mut) { [weak self] result, error in
            guard let updatedUser = result?.data?.updateAddress?.changedAddress?.user?.fragments.completeUser,
                let user = User(completeUser: updatedUser),
                error == nil
            else {
                callback(.error(UserError.updateAddressFailed)); return;
            }
            self?.user = user
            callback(.success(user))
        }
    }
    
    func usePhoto(photo: Photo, callback: @escaping UserCallback) {
        guard let user = self.user else { callback(.error(.unknownFailure)); return }
        let input = CreatePhotoInput(largeThumbnailUrl: photo.thumbnails.large.absoluteString,
                                     expectedDeliveryDate: photo.expectedDeliveryDate,
                                     imageUrl: photo.imageURL.absoluteString,
                                     mediumThumbnailUrl: photo.thumbnails.medium.absoluteString,
                                     filmId: user.filmId,
                                     smallThumbnailUrl: photo.thumbnails.small.absoluteString,
                                     userId: user.id)
        let mut = CreatePhotoMutation(input: input)
        graphql.client.perform(mutation: mut) { [weak self] result, error in
            guard let completeUser = result?.data?.createPhoto?.changedPhoto?.user?.fragments.completeUser,
                let user = User(completeUser: completeUser),
                error == nil
                else {
                    callback(.error(.unknownFailure)); return
            }
            self?.user = user
            callback(.success(user))
        }
    }
    
    func buyFilm(capacity: Int, callback: @escaping UserCallback) {
        guard let user = self.user else { return }
        let input = UpdateUserInput(id: user.id, remainingPhotos: user.remainingPhotos + capacity)
        let mut = UpdateUserMutation(input: input)
        graphql.client.perform(mutation: mut) { [weak self] result, error in
            guard let completeUser = result?.data?.updateUser?.changedUser?.fragments.completeUser,
                let user = User(completeUser: completeUser),
                error == nil
            else {
                callback(.error(.buyFilmFailed)); return
            }
            self?.user = user
            callback(.success(user))
        }
    }
}

enum UserError: Error {
    case loginFailed
    case signupFailed
    case updateAddressFailed
    case buyFilmFailed
    case unknownFailure
    
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
