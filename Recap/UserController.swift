//
//  UserController.swift
//  Recap
//
//  Created by Alex Brashear on 4/22/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import UIKit
import Apollo
import FacebookCore
import FacebookLogin

typealias UserCallback = (Result<User, UserError>) -> ()
typealias PhotoIDDateCallback = (Result<(String, String), PhotoError>) -> Void
typealias SocialLoginCallback = (Result<Void, SocialError>) -> ()
typealias PhotosCallback = (Result<[Photo], PhotoError>) -> ()
typealias PhotoErrorOnlyCallback = (Result<Void, PhotoError>) -> Void
typealias VerifyInviteCodeCallback = (Result<Void, UserError>) -> Void
typealias CreateAddressCallback = (Result<Address, UserError>) -> Void

struct UserNotification {
    static let userDidUpdate = Notification.Name("userDidUpdate")
    static let userConnectedFacebook = Notification.Name("userConnectedFacebook")
}

class UserController {
    
    fileprivate var graphql: ApolloWrapper
    private var store: PersistanceManager
    
    var user: User? {
        didSet {
            store.user = user
        }
    }
    
    var isLoggedIntoFacebook: Bool {
        return AccessToken.current != nil
    }
    
    init(graphql: ApolloWrapper, persistanceManager: PersistanceManager) {
        self.graphql = graphql
        self.store = persistanceManager
    }
    
    func loadUser() {
        user = store.user
    }
    
    func deletePaymentInformation() {
        guard let user = user else { return }
        let input = UpdateUserInput(id: user.id, customerId: "")
        updateUser(input: input) { result in
            switch result {
            case .success:
                return
            case .error:
                return
            }
        }
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
        
        let createAddressInput = CreateAddressInput(city: address.city, secondaryLine: address.secondaryLine, name: address.name, primaryLine: address.primaryLine, zipCode: address.zip, state: address.state)
        let createUserInput = CreateUserInput(remainingPhotos: 2, inviteCode: String.randomString(length: 6), username: email, address: createAddressInput, password: password)
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
    
    func loginWithSocial(callback: @escaping SocialLoginCallback) {
        guard AccessToken.current == nil else {
            callback(.success())
            return
        }
        let loginManager = LoginManager()
        loginManager.logIn([ .publicProfile, .userFriends ]) { [weak self] loginResult in
            switch loginResult {
            case .failed:
                callback(.error(.failed))
            case .cancelled:
                callback(.error(.userCancelledLogin))
            case let .success(_, _, token):
                guard let id = token.userId else { return callback(.error(.failedToLinkAccount)) }
                self?.storeFacebookID(id: id, callback: callback)
            }
        }
    }
    
    private func storeFacebookID(id: String, callback: @escaping SocialLoginCallback) {
        guard let user = self.user else { return }
        let input = UpdateUserInput(id: user.id, facebookId: id)
        updateUser(input: input) { result in
            switch result {
            case .error:
                callback(.error(.failedToLinkAccount))
            case .success:
                NotificationCenter.default.post(name: UserNotification.userConnectedFacebook, object: nil)
                callback(.success())
            }
        }
    }
    
    func verifyInviteCode(code: String, callback: @escaping VerifyInviteCodeCallback) {
        let input = UserWhereArgs(inviteCode: UserInviteCodeWhereArgs(eq: code))
        let query = VerifyInviteCodeQuery(input: input)
        graphql.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result, error in
            guard let edges = result?.data?.viewer?.allUsers?.edges, error == nil, edges.count >= 1 else {
                return callback(.error(.invalidInviteCode))
            }
            callback(.success())
        }
    }
}

// MARK: - Mutations

extension UserController {
    func usePhotos(numPhotos: Int, callback: @escaping UserCallback) {
        guard let user = self.user else { return }
        let input = UpdateUserInput(id: user.id, remainingPhotos: user.remainingPhotos - numPhotos)
        updateUser(input: input, callback: callback)
    }
    
    func createAddress(newAddress: Address, callback: @escaping CreateAddressCallback) {
        let input = CreateAddressInput(city: newAddress.city, secondaryLine: newAddress.secondaryLine, name: newAddress.name, primaryLine: newAddress.primaryLine, zipCode: newAddress.zip, state: newAddress.state)
        let mut = CreateAddressMutation(input: input)
        graphql.client.perform(mutation: mut) { result, error in
            guard let completeAddress = result?.data?.createAddress?.changedAddress?.fragments.completeAddress,
                error == nil
            else {
                callback(.error(.uploadAddressFailed)); return;
            }
            let address = Address(completeAddress: completeAddress)
            callback(.success(address))
        }
    }
    
    func updateAddress(newAddress: Address, callback: @escaping UserCallback) {
        guard let user = self.user else { return }
        let input = UpdateAddressInput(id: user.address.id, userId: user.id, city: newAddress.city, secondaryLine: newAddress.secondaryLine, name: newAddress.name, primaryLine: newAddress.primaryLine, zipCode: newAddress.zip, state: newAddress.state)
        let mut = UpdateAddressMutation(input: input)
        graphql.client.perform(mutation: mut) { [weak self] result, error in
            guard let updatedUser = result?.data?.updateAddress?.changedAddress?.user?.fragments.completeUser,
                let user = User(completeUser: updatedUser),
                error == nil
            else {
                callback(.error(UserError.updateAddressFailed)); return;
            }
            self?.user = user
            NotificationCenter.default.post(name: UserNotification.userDidUpdate, object: nil)
            callback(.success(user))
        }
    }
    
    typealias AddressesResult = Result<[Address], UserError>
    typealias AddressesCompletion = (AddressesResult) -> Void
    
    func fetchFacebookAddresses(IDs: [String], completion: @escaping AddressesCompletion) {
        guard !IDs.isEmpty else { return completion(.success([])) }
        let input = UserWhereArgs(facebookId: UserFacebookIdWhereArgs(in: IDs))
        let query = FacebookUsersQuery(input: input)
        graphql.client.fetch(query: query) { result, error in
            guard let edges = result?.data?.viewer?.allUsers?.edges, error == nil else {
                return completion(.error(.couldNotFetchFacebookAddresses))
            }
            var addresses = [Address]()
            for edge in edges {
                guard let completeAddress = edge?.node.address?.fragments.completeAddress else { continue }
                addresses.append(Address(completeAddress: completeAddress))
            }
            // commenting this out for now because I think we will run into issues if someone leaves recap or
            // facebook and we still have their ID.
            // guard !addresses.isEmpty else { return completion(.error(.couldNotFetchFacebookAddresses)) }
            completion(.success(addresses))
        }
    }
    
    func createPhoto(photo: Photo, callback: @escaping PhotoIDDateCallback) {
        guard let user = self.user else { callback(.error(.unknownFailure)); return }
        let input = CreatePhotoInput(senderId: user.id, imageUrl: photo.imageURL.absoluteString)
        graphql.client.perform(mutation: CreatePhotoMutation(input: input)) { result, error in
            guard let changedPhoto = result?.data?.createPhoto?.changedPhoto, error == nil else {
                    callback(.error(.unknownFailure)); return
            }
            let tuple = (changedPhoto.id, changedPhoto.createdAt)
            callback(.success(tuple))
        }
    }
    
    func createPhotoConnection(photoId: GraphQLID, addressId: GraphQLID, callback: @escaping PhotoErrorOnlyCallback) {
        let input = AddToPhotoAddressMapConnectionInput(addressId: addressId, photoId: photoId)
        let mut = CreatePhotoAddressConnectionMutation(input: input)
        graphql.client.perform(mutation: mut) { result, error in
            guard let _ = result?.data?.addToPhotoAddressMapConnection?.changedPhotoAddressMap?.photo?.id, error == nil else {
                return callback(.error(.unknownFailure))
            }
            callback(.success())
        }
    }
    
    func createCustomer(customerId: String, callback: @escaping UserCallback) {
        guard let user = self.user else { return }
        let input = UpdateUserInput(id: user.id, customerId: customerId)
        updateUser(input: input) { result in
            switch result {
            case .error:
                callback(.error(.createCustomerFailed))
            case .success:
                callback(result)
            }
        }
    }
    
    func buyFilm(capacity: Int, callback: @escaping UserCallback) {
        guard let user = self.user else { return }
        let input = UpdateUserInput(id: user.id, remainingPhotos: user.remainingPhotos + capacity)
        updateUser(input: input) { result in
            switch result {
            case .error:
                callback(.error(.buyFilmFailed))
            case .success:
                callback(result)
            }
        }
    }
    
    func getFilm(callback: @escaping PhotosCallback) {
        graphql.client.fetch(query: UserPhotosQuery()) { result, error in
            guard let edges = result?.data?.viewer?.user?.photos?.edges, error == nil else {
                callback(.error(.unknownFailure)); return
            }
            var photos = [Photo]()
            for edge in edges {
                guard let completePhoto = edge?.node.fragments.completePhoto,
                    let photo = Photo(completePhoto: completePhoto) else { continue }
                photos.append(photo)
            }
            callback(.success(photos))
        }
    }
}

// MARK: - Helpers

extension UserController {
    fileprivate func updateUser(input: UpdateUserInput, callback: @escaping UserCallback) {
        let mut = UpdateUserMutation(input: input)
        graphql.client.perform(mutation: mut) { [weak self] result, error in
            guard let completeUser = result?.data?.updateUser?.changedUser?.fragments.completeUser,
                let user = User(completeUser: completeUser),
                error == nil
                else {
                    callback(.error(.unknownFailure)); return
            }
            self?.user = user
            NotificationCenter.default.post(name: UserNotification.userDidUpdate, object: nil)
            callback(.success(user))
        }
    }
}

enum UserError: AlertableError {
    case loginFailed
    case signupFailed
    case updateAddressFailed
    case buyFilmFailed
    case unknownFailure
    case invalidInviteCode
    case couldNotFetchFacebookAddresses
    case uploadAddressFailed
    case createCustomerFailed
    
    var localizedTitle: String {
        switch self {
        case .loginFailed:
            return "Login Failed"
        case .signupFailed:
            return "Sign up Failed"
        case .updateAddressFailed:
            return "Where's that?"
        case .buyFilmFailed:
            return "Purchase Failed"
        case .unknownFailure:
            return "Something went wrong"
        case .invalidInviteCode:
            return "Invalid Invite Code"
        case .couldNotFetchFacebookAddresses:
            return "Where's that?"
        case .uploadAddressFailed:
            return "Storing your address failed"
        case .createCustomerFailed:
            return "Something went wrong"
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .loginFailed:
            return "Did ya spell it right? Are you connected to the internet? Try again or get help from help@recap-app.com"
        case .signupFailed:
            return "Your address checks out but we were unable to sign you up. You may be using an email that is already linked to an account. Check your email and try again or get help from help@recap-app.com"
        case .updateAddressFailed:
            return "We can't verify that address. Make sure you're on the internet and it's spelt right."
        case .buyFilmFailed:
            return "Please try again or contact us at help@recap-app.com"
        case .unknownFailure:
            return "and we don't know what! Please send us an email at help@recap-app.com with details."
        case .invalidInviteCode:
            return "Check that you entered the right code and try again, or vist recap-app.com to learn more."
        case .couldNotFetchFacebookAddresses:
            return "We ran into an issue getting your facebook friends address. Please check your internet connection and try again or send us an email at help@recap-app.com with details."
        case .uploadAddressFailed:
            return "The address checks out but there was an issue storing it. Please check your internet connection and try again or send us an email at help@recap-app.com with details."
        case .createCustomerFailed:
            return "Check that you have a good internet connection and please try again or contact us at help@recap-app.com"
        }
    }
}

enum SocialError: AlertableError {
    case userCancelledLogin
    case failedToLinkAccount
    case failed
    
    var localizedTitle: String {
        return "We couldn't link your Facebook"
    }
    
    var localizedDescription: String {
        switch self {
        case .userCancelledLogin:
            return "It looks like your facebook login attempt was canceled before it completed, please try again or contact help@recap-app.com"
        case .failed:
            return "We had trouble connecting your facebook account, please try again or contact help@recap-app.com"
        case .failedToLinkAccount:
            return "You successfully logged in to Facebook but we had trouble linking your account. Though you will appear in your friends queues, they will be unable to send to you. Please contact help@recap-app.com so we can resolve this!"
        }
    }
}

extension String {
    static func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
