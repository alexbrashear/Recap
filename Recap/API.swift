//  This file was automatically generated and should not be edited.

import Apollo

public struct CreatePhotoInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(sender: CreateUserInput? = nil, senderId: GraphQLID? = nil, imageUrl: String, clientMutationId: GraphQLID? = nil) {
    graphQLMap = ["sender": sender, "senderId": senderId, "imageURL": imageUrl, "clientMutationId": clientMutationId]
  }
}

public struct CreateUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(remainingPhotos: Int, username: String, address: CreateAddressInput? = nil, addressId: GraphQLID? = nil, password: String, facebookId: String? = nil, clientMutationId: GraphQLID? = nil) {
    graphQLMap = ["remainingPhotos": remainingPhotos, "username": username, "address": address, "addressId": addressId, "password": password, "facebookId": facebookId, "clientMutationId": clientMutationId]
  }
}

public struct CreateAddressInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(user: CreateUserInput? = nil, userId: GraphQLID? = nil, city: String, secondaryLine: String? = nil, name: String, primaryLine: String, zipCode: String, state: String, clientMutationId: GraphQLID? = nil) {
    graphQLMap = ["user": user, "userId": userId, "city": city, "secondaryLine": secondaryLine, "name": name, "primaryLine": primaryLine, "zipCode": zipCode, "state": state, "clientMutationId": clientMutationId]
  }
}

public struct AddToPhotoAddressMapConnectionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(addressId: GraphQLID, photoId: GraphQLID, clientMutationId: String? = nil) {
    graphQLMap = ["addressId": addressId, "photoId": photoId, "clientMutationId": clientMutationId]
  }
}

public struct LoginUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(username: String, password: String, clientMutationId: String? = nil) {
    graphQLMap = ["username": username, "password": password, "clientMutationId": clientMutationId]
  }
}

public struct UpdateAddressInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, userId: GraphQLID? = nil, city: String? = nil, secondaryLine: String? = nil, name: String? = nil, primaryLine: String? = nil, zipCode: String? = nil, state: String? = nil, clientMutationId: String? = nil) {
    graphQLMap = ["id": id, "userId": userId, "city": city, "secondaryLine": secondaryLine, "name": name, "primaryLine": primaryLine, "zipCode": zipCode, "state": state, "clientMutationId": clientMutationId]
  }
}

public struct UpdateUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: GraphQLID, remainingPhotos: Int? = nil, username: String? = nil, addressId: GraphQLID? = nil, password: String? = nil, facebookId: String? = nil, clientMutationId: String? = nil) {
    graphQLMap = ["id": id, "remainingPhotos": remainingPhotos, "username": username, "addressId": addressId, "password": password, "facebookId": facebookId, "clientMutationId": clientMutationId]
  }
}

/// Where filter arguments for the User type
public struct UserWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: UserIdWhereArgs? = nil, remainingPhotos: UserRemainingPhotosWhereArgs? = nil, username: UserUsernameWhereArgs? = nil, createdAt: UserCreatedAtWhereArgs? = nil, address: AddressWhereArgs? = nil, lastLogin: UserLastLoginWhereArgs? = nil, photos: PhotoWhereArgs? = nil, password: UserPasswordWhereArgs? = nil, modifiedAt: UserModifiedAtWhereArgs? = nil, roles: UserRolesWhereArgs? = nil, facebookId: UserFacebookIdWhereArgs? = nil, addressId: UserAddressIdWhereArgs? = nil, or: [UserWhereArgs?]? = nil, and: [UserWhereArgs?]? = nil) {
    graphQLMap = ["id": id, "remainingPhotos": remainingPhotos, "username": username, "createdAt": createdAt, "address": address, "lastLogin": lastLogin, "photos": photos, "password": password, "modifiedAt": modifiedAt, "roles": roles, "facebookId": facebookId, "addressId": addressId, "OR": or, "AND": and]
  }
}

public struct UserIdWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: GraphQLID? = nil, ne: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "in": `in`, "notIn": notIn, "isNull": isNull]
  }
}

public struct UserRemainingPhotosWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: Int? = nil, ne: Int? = nil, gt: Int? = nil, gte: Int? = nil, lt: Int? = nil, lte: Int? = nil, between: [Int?]? = nil, notBetween: [Int?]? = nil, `in`: [Int?]? = nil, notIn: [Int?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct UserUsernameWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct UserCreatedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

/// Where filter arguments for the Address type
public struct AddressWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(photosReceived: AddressPhotosReceivedWhereArgs? = nil, modifiedAt: AddressModifiedAtWhereArgs? = nil, id: AddressIdWhereArgs? = nil, createdAt: AddressCreatedAtWhereArgs? = nil, user: UserWhereArgs? = nil, city: AddressCityWhereArgs? = nil, secondaryLine: AddressSecondaryLineWhereArgs? = nil, name: AddressNameWhereArgs? = nil, primaryLine: AddressPrimaryLineWhereArgs? = nil, zipCode: AddressZipCodeWhereArgs? = nil, state: AddressStateWhereArgs? = nil, userId: AddressUserIdWhereArgs? = nil, or: [AddressWhereArgs?]? = nil, and: [AddressWhereArgs?]? = nil) {
    graphQLMap = ["photosReceived": photosReceived, "modifiedAt": modifiedAt, "id": id, "createdAt": createdAt, "user": user, "city": city, "secondaryLine": secondaryLine, "name": name, "primaryLine": primaryLine, "zipCode": zipCode, "state": state, "userId": userId, "OR": or, "AND": and]
  }
}

/// Select objects by filtering on objects in a connection
public struct AddressPhotosReceivedWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(edge: PhotoAddressMapEdgeWhereArgs? = nil, node: PhotoWhereArgs? = nil) {
    graphQLMap = ["edge": edge, "node": node]
  }
}

/// Where filter arguments for the PhotoAddressMap type
public struct PhotoAddressMapEdgeWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(createdAt: PhotoAddressMapCreatedAtWhereArgs? = nil, modifiedAt: PhotoAddressMapModifiedAtWhereArgs? = nil) {
    graphQLMap = ["createdAt": createdAt, "modifiedAt": modifiedAt]
  }
}

public struct PhotoAddressMapCreatedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct PhotoAddressMapModifiedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

/// Where filter arguments for the Photo type
public struct PhotoWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(id: PhotoIdWhereArgs? = nil, sender: UserWhereArgs? = nil, createdAt: PhotoCreatedAtWhereArgs? = nil, recipients: PhotoRecipientsWhereArgs? = nil, modifiedAt: PhotoModifiedAtWhereArgs? = nil, imageUrl: PhotoImageUrlWhereArgs? = nil, senderId: PhotoSenderIdWhereArgs? = nil, or: [PhotoWhereArgs?]? = nil, and: [PhotoWhereArgs?]? = nil) {
    graphQLMap = ["id": id, "sender": sender, "createdAt": createdAt, "recipients": recipients, "modifiedAt": modifiedAt, "imageURL": imageUrl, "senderId": senderId, "OR": or, "AND": and]
  }
}

public struct PhotoIdWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: GraphQLID? = nil, ne: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "in": `in`, "notIn": notIn, "isNull": isNull]
  }
}

public struct PhotoCreatedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

/// Select objects by filtering on objects in a connection
public struct PhotoRecipientsWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(edge: PhotoAddressMapEdgeWhereArgs? = nil, node: AddressWhereArgs? = nil) {
    graphQLMap = ["edge": edge, "node": node]
  }
}

public struct PhotoModifiedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct PhotoImageUrlWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct PhotoSenderIdWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: GraphQLID? = nil, ne: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "in": `in`, "notIn": notIn, "isNull": isNull]
  }
}

public struct AddressModifiedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct AddressIdWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: GraphQLID? = nil, ne: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "in": `in`, "notIn": notIn, "isNull": isNull]
  }
}

public struct AddressCreatedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct AddressCityWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct AddressSecondaryLineWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct AddressNameWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct AddressPrimaryLineWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct AddressZipCodeWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct AddressStateWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct AddressUserIdWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: GraphQLID? = nil, ne: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "in": `in`, "notIn": notIn, "isNull": isNull]
  }
}

public struct UserLastLoginWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct UserPasswordWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct UserModifiedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

/// Select objects by filtering on objects in a connection
public struct UserRolesWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(edge: UserRolesEdgeWhereArgs? = nil, node: RoleWhereArgs? = nil) {
    graphQLMap = ["edge": edge, "node": node]
  }
}

/// Where filter arguments for the UserRoles type
public struct UserRolesEdgeWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(accessLevel: UserRolesAccessLevelWhereArgs? = nil, modifiedAt: UserRolesModifiedAtWhereArgs? = nil, createdAt: UserRolesCreatedAtWhereArgs? = nil) {
    graphQLMap = ["accessLevel": accessLevel, "modifiedAt": modifiedAt, "createdAt": createdAt]
  }
}

public struct UserRolesAccessLevelWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: AccessLevel? = nil, ne: AccessLevel? = nil, gt: AccessLevel? = nil, gte: AccessLevel? = nil, lt: AccessLevel? = nil, lte: AccessLevel? = nil, between: [AccessLevel?]? = nil, notBetween: [AccessLevel?]? = nil, `in`: [AccessLevel?]? = nil, notIn: [AccessLevel?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

/// Values for the AccessLevel enum
public enum AccessLevel: String {
  case admin = "admin"
  case readwrite = "readwrite"
  case readonly = "readonly"
}

extension AccessLevel: JSONDecodable, JSONEncodable {}

public struct UserRolesModifiedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct UserRolesCreatedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

/// Where filter arguments for the Role type
public struct RoleWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(name: RoleNameWhereArgs? = nil, id: RoleIdWhereArgs? = nil, modifiedAt: RoleModifiedAtWhereArgs? = nil, members: RoleMembersWhereArgs? = nil, createdAt: RoleCreatedAtWhereArgs? = nil, or: [RoleWhereArgs?]? = nil, and: [RoleWhereArgs?]? = nil) {
    graphQLMap = ["name": name, "id": id, "modifiedAt": modifiedAt, "members": members, "createdAt": createdAt, "OR": or, "AND": and]
  }
}

public struct RoleNameWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct RoleIdWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: GraphQLID? = nil, ne: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "in": `in`, "notIn": notIn, "isNull": isNull]
  }
}

public struct RoleModifiedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

/// Select objects by filtering on objects in a connection
public struct RoleMembersWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(edge: UserRolesEdgeWhereArgs? = nil, node: UserWhereArgs? = nil) {
    graphQLMap = ["edge": edge, "node": node]
  }
}

public struct RoleCreatedAtWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct UserFacebookIdWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: String? = nil, ne: String? = nil, gt: String? = nil, gte: String? = nil, lt: String? = nil, lte: String? = nil, between: [String?]? = nil, notBetween: [String?]? = nil, `in`: [String?]? = nil, notIn: [String?]? = nil, like: String? = nil, notLike: String? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "gt": gt, "gte": gte, "lt": lt, "lte": lte, "between": between, "notBetween": notBetween, "in": `in`, "notIn": notIn, "like": like, "notLike": notLike, "isNull": isNull]
  }
}

public struct UserAddressIdWhereArgs: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(eq: GraphQLID? = nil, ne: GraphQLID? = nil, `in`: [GraphQLID?]? = nil, notIn: [GraphQLID?]? = nil, isNull: Bool? = nil) {
    graphQLMap = ["eq": eq, "ne": ne, "in": `in`, "notIn": notIn, "isNull": isNull]
  }
}

public final class CreatePhotoMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreatePhoto($input: CreatePhotoInput!) {" +
    "  createPhoto(input: $input) {" +
    "    __typename" +
    "    changedPhoto {" +
    "      __typename" +
    "      id" +
    "    }" +
    "  }" +
    "}"

  public let input: CreatePhotoInput

  public init(input: CreatePhotoInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLMappable {
    /// Create objects of type Photo.
    public let createPhoto: CreatePhoto?

    public init(reader: GraphQLResultReader) throws {
      createPhoto = try reader.optionalValue(for: Field(responseName: "createPhoto", arguments: ["input": reader.variables["input"]]))
    }

    public struct CreatePhoto: GraphQLMappable {
      public let __typename: String
      /// The mutated Photo.
      public let changedPhoto: ChangedPhoto?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        changedPhoto = try reader.optionalValue(for: Field(responseName: "changedPhoto"))
      }

      public struct ChangedPhoto: GraphQLMappable {
        public let __typename: String
        /// A globally unique ID.
        public let id: GraphQLID

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          id = try reader.value(for: Field(responseName: "id"))
        }
      }
    }
  }
}

public final class CreatePhotoAddressConnectionMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreatePhotoAddressConnection($input: AddToPhotoAddressMapConnectionInput!) {" +
    "  addToPhotoAddressMapConnection(input: $input) {" +
    "    __typename" +
    "    changedPhotoAddressMap {" +
    "      __typename" +
    "      photo {" +
    "        __typename" +
    "        id" +
    "      }" +
    "    }" +
    "  }" +
    "}"

  public let input: AddToPhotoAddressMapConnectionInput

  public init(input: AddToPhotoAddressMapConnectionInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLMappable {
    /// Adds a connection between an object of type
    /// 'Address' and an object of type Photo. You can edit
    /// the 'PhotoAddressMap' bridge type to add/remove custom fields for this connection.
    /// 
    public let addToPhotoAddressMapConnection: AddToPhotoAddressMapConnection?

    public init(reader: GraphQLResultReader) throws {
      addToPhotoAddressMapConnection = try reader.optionalValue(for: Field(responseName: "addToPhotoAddressMapConnection", arguments: ["input": reader.variables["input"]]))
    }

    public struct AddToPhotoAddressMapConnection: GraphQLMappable {
      public let __typename: String
      /// The mutated PhotoAddressMap.
      public let changedPhotoAddressMap: ChangedPhotoAddressMap?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        changedPhotoAddressMap = try reader.optionalValue(for: Field(responseName: "changedPhotoAddressMap"))
      }

      public struct ChangedPhotoAddressMap: GraphQLMappable {
        public let __typename: String
        public let photo: Photo?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          photo = try reader.optionalValue(for: Field(responseName: "photo"))
        }

        public struct Photo: GraphQLMappable {
          public let __typename: String
          /// A globally unique ID.
          public let id: GraphQLID

          public init(reader: GraphQLResultReader) throws {
            __typename = try reader.value(for: Field(responseName: "__typename"))
            id = try reader.value(for: Field(responseName: "id"))
          }
        }
      }
    }
  }
}

public final class UserPhotosQuery: GraphQLQuery {
  public static let operationDefinition =
    "query UserPhotos {" +
    "  viewer {" +
    "    __typename" +
    "    user {" +
    "      __typename" +
    "      photos {" +
    "        __typename" +
    "        edges {" +
    "          __typename" +
    "          node {" +
    "            __typename" +
    "            ...completePhoto" +
    "          }" +
    "        }" +
    "      }" +
    "    }" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(CompletePhoto.fragmentDefinition).appending(CompleteAddress.fragmentDefinition)
  public init() {
  }

  public struct Data: GraphQLMappable {
    public let viewer: Viewer?

    public init(reader: GraphQLResultReader) throws {
      viewer = try reader.optionalValue(for: Field(responseName: "viewer"))
    }

    public struct Viewer: GraphQLMappable {
      public let __typename: String
      /// Returns the currently logged in user and is also the entry point for queries that leverage RELATION scoped permissions.
      public let user: User?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        user = try reader.optionalValue(for: Field(responseName: "user"))
      }

      public struct User: GraphQLMappable {
        public let __typename: String
        /// The reverse field of 'sender' in 1:M connection
        /// with type 'undefined'.
        public let photos: Photo?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          photos = try reader.optionalValue(for: Field(responseName: "photos"))
        }

        public struct Photo: GraphQLMappable {
          public let __typename: String
          /// The set of edges in this page.
          public let edges: [Edge?]?

          public init(reader: GraphQLResultReader) throws {
            __typename = try reader.value(for: Field(responseName: "__typename"))
            edges = try reader.optionalList(for: Field(responseName: "edges"))
          }

          public struct Edge: GraphQLMappable {
            public let __typename: String
            /// The node value for the edge.
            public let node: Node

            public init(reader: GraphQLResultReader) throws {
              __typename = try reader.value(for: Field(responseName: "__typename"))
              node = try reader.value(for: Field(responseName: "node"))
            }

            public struct Node: GraphQLMappable {
              public let __typename: String

              public let fragments: Fragments

              public init(reader: GraphQLResultReader) throws {
                __typename = try reader.value(for: Field(responseName: "__typename"))

                let completePhoto = try CompletePhoto(reader: reader)
                fragments = Fragments(completePhoto: completePhoto)
              }

              public struct Fragments {
                public let completePhoto: CompletePhoto
              }
            }
          }
        }
      }
    }
  }
}

public final class SignupUserMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation SignupUser($user: CreateUserInput!) {" +
    "  createUser(input: $user) {" +
    "    __typename" +
    "    token" +
    "    changedUser {" +
    "      __typename" +
    "      ...completeUser" +
    "    }" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(CompleteUser.fragmentDefinition).appending(CompleteAddress.fragmentDefinition).appending(CompletePhoto.fragmentDefinition)

  public let user: CreateUserInput

  public init(user: CreateUserInput) {
    self.user = user
  }

  public var variables: GraphQLMap? {
    return ["user": user]
  }

  public struct Data: GraphQLMappable {
    /// Create objects of type User.
    public let createUser: CreateUser?

    public init(reader: GraphQLResultReader) throws {
      createUser = try reader.optionalValue(for: Field(responseName: "createUser", arguments: ["input": reader.variables["user"]]))
    }

    public struct CreateUser: GraphQLMappable {
      public let __typename: String
      /// The user's authentication token. Embed this under the
      /// 'Authorization' header with the format 'Bearer <token>'
      /// 
      public let token: String?
      /// The mutated User.
      public let changedUser: ChangedUser?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        token = try reader.optionalValue(for: Field(responseName: "token"))
        changedUser = try reader.optionalValue(for: Field(responseName: "changedUser"))
      }

      public struct ChangedUser: GraphQLMappable {
        public let __typename: String

        public let fragments: Fragments

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))

          let completeUser = try CompleteUser(reader: reader)
          fragments = Fragments(completeUser: completeUser)
        }

        public struct Fragments {
          public let completeUser: CompleteUser
        }
      }
    }
  }
}

public final class LoginUserMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation LoginUser($input: LoginUserInput!) {" +
    "  loginUser(input: $input) {" +
    "    __typename" +
    "    token" +
    "    user {" +
    "      __typename" +
    "      ...completeUser" +
    "    }" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(CompleteUser.fragmentDefinition).appending(CompleteAddress.fragmentDefinition).appending(CompletePhoto.fragmentDefinition)

  public let input: LoginUserInput

  public init(input: LoginUserInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLMappable {
    public let loginUser: LoginUser?

    public init(reader: GraphQLResultReader) throws {
      loginUser = try reader.optionalValue(for: Field(responseName: "loginUser", arguments: ["input": reader.variables["input"]]))
    }

    public struct LoginUser: GraphQLMappable {
      public let __typename: String
      /// The user's authentication token. Embed this under the
      /// 'Authorization' header with the format 'Bearer <token>'
      /// 
      public let token: String?
      /// The mutated User.
      public let user: User?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        token = try reader.optionalValue(for: Field(responseName: "token"))
        user = try reader.optionalValue(for: Field(responseName: "user"))
      }

      public struct User: GraphQLMappable {
        public let __typename: String

        public let fragments: Fragments

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))

          let completeUser = try CompleteUser(reader: reader)
          fragments = Fragments(completeUser: completeUser)
        }

        public struct Fragments {
          public let completeUser: CompleteUser
        }
      }
    }
  }
}

public final class UpdateAddressMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation UpdateAddress($input: UpdateAddressInput!) {" +
    "  updateAddress(input: $input) {" +
    "    __typename" +
    "    changedAddress {" +
    "      __typename" +
    "      ...completeAddress" +
    "      user {" +
    "        __typename" +
    "        ...completeUser" +
    "      }" +
    "    }" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(CompleteUser.fragmentDefinition).appending(CompleteAddress.fragmentDefinition).appending(CompletePhoto.fragmentDefinition)

  public let input: UpdateAddressInput

  public init(input: UpdateAddressInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLMappable {
    /// Update objects of type Address.
    public let updateAddress: UpdateAddress?

    public init(reader: GraphQLResultReader) throws {
      updateAddress = try reader.optionalValue(for: Field(responseName: "updateAddress", arguments: ["input": reader.variables["input"]]))
    }

    public struct UpdateAddress: GraphQLMappable {
      public let __typename: String
      /// The mutated Address.
      public let changedAddress: ChangedAddress?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        changedAddress = try reader.optionalValue(for: Field(responseName: "changedAddress"))
      }

      public struct ChangedAddress: GraphQLMappable {
        public let __typename: String
        /// The reverse field of 'address' in M:1 connection
        /// with type 'undefined'.
        public let user: User?

        public let fragments: Fragments

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          user = try reader.optionalValue(for: Field(responseName: "user"))

          let completeAddress = try CompleteAddress(reader: reader)
          fragments = Fragments(completeAddress: completeAddress)
        }

        public struct Fragments {
          public let completeAddress: CompleteAddress
        }

        public struct User: GraphQLMappable {
          public let __typename: String

          public let fragments: Fragments

          public init(reader: GraphQLResultReader) throws {
            __typename = try reader.value(for: Field(responseName: "__typename"))

            let completeUser = try CompleteUser(reader: reader)
            fragments = Fragments(completeUser: completeUser)
          }

          public struct Fragments {
            public let completeUser: CompleteUser
          }
        }
      }
    }
  }
}

public final class UpdateUserMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation UpdateUser($input: UpdateUserInput!) {" +
    "  updateUser(input: $input) {" +
    "    __typename" +
    "    changedUser {" +
    "      __typename" +
    "      ...completeUser" +
    "    }" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(CompleteUser.fragmentDefinition).appending(CompleteAddress.fragmentDefinition).appending(CompletePhoto.fragmentDefinition)

  public let input: UpdateUserInput

  public init(input: UpdateUserInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLMappable {
    /// Update objects of type User.
    public let updateUser: UpdateUser?

    public init(reader: GraphQLResultReader) throws {
      updateUser = try reader.optionalValue(for: Field(responseName: "updateUser", arguments: ["input": reader.variables["input"]]))
    }

    public struct UpdateUser: GraphQLMappable {
      public let __typename: String
      /// The mutated User.
      public let changedUser: ChangedUser?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        changedUser = try reader.optionalValue(for: Field(responseName: "changedUser"))
      }

      public struct ChangedUser: GraphQLMappable {
        public let __typename: String

        public let fragments: Fragments

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))

          let completeUser = try CompleteUser(reader: reader)
          fragments = Fragments(completeUser: completeUser)
        }

        public struct Fragments {
          public let completeUser: CompleteUser
        }
      }
    }
  }
}

public final class FacebookUsersQuery: GraphQLQuery {
  public static let operationDefinition =
    "query FacebookUsers($input: UserWhereArgs) {" +
    "  viewer {" +
    "    __typename" +
    "    allUsers(where: $input) {" +
    "      __typename" +
    "      edges {" +
    "        __typename" +
    "        node {" +
    "          __typename" +
    "          address {" +
    "            __typename" +
    "            ...completeAddress" +
    "          }" +
    "        }" +
    "      }" +
    "    }" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(CompleteAddress.fragmentDefinition)

  public let input: UserWhereArgs?

  public init(input: UserWhereArgs? = nil) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLMappable {
    public let viewer: Viewer?

    public init(reader: GraphQLResultReader) throws {
      viewer = try reader.optionalValue(for: Field(responseName: "viewer"))
    }

    public struct Viewer: GraphQLMappable {
      public let __typename: String
      /// Sift through all objects of type 'User'.
      public let allUsers: AllUser?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        allUsers = try reader.optionalValue(for: Field(responseName: "allUsers", arguments: ["where": reader.variables["input"]]))
      }

      public struct AllUser: GraphQLMappable {
        public let __typename: String
        /// The set of edges in this page.
        public let edges: [Edge?]?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          edges = try reader.optionalList(for: Field(responseName: "edges"))
        }

        public struct Edge: GraphQLMappable {
          public let __typename: String
          /// The node value for the edge.
          public let node: Node

          public init(reader: GraphQLResultReader) throws {
            __typename = try reader.value(for: Field(responseName: "__typename"))
            node = try reader.value(for: Field(responseName: "node"))
          }

          public struct Node: GraphQLMappable {
            public let __typename: String
            public let address: Address?

            public init(reader: GraphQLResultReader) throws {
              __typename = try reader.value(for: Field(responseName: "__typename"))
              address = try reader.optionalValue(for: Field(responseName: "address"))
            }

            public struct Address: GraphQLMappable {
              public let __typename: String

              public let fragments: Fragments

              public init(reader: GraphQLResultReader) throws {
                __typename = try reader.value(for: Field(responseName: "__typename"))

                let completeAddress = try CompleteAddress(reader: reader)
                fragments = Fragments(completeAddress: completeAddress)
              }

              public struct Fragments {
                public let completeAddress: CompleteAddress
              }
            }
          }
        }
      }
    }
  }
}

public struct CompletePhoto: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment completePhoto on Photo {" +
    "  __typename" +
    "  id" +
    "  imageURL" +
    "  recipients {" +
    "    __typename" +
    "    edges {" +
    "      __typename" +
    "      node {" +
    "        __typename" +
    "        ...completeAddress" +
    "      }" +
    "    }" +
    "  }" +
    "  createdAt" +
    "}"

  public static let possibleTypes = ["Photo"]

  public let __typename: String
  /// A globally unique ID.
  public let id: GraphQLID
  public let imageUrl: String
  public let recipients: Recipient?
  /// When paired with the Node interface, this is an automatically managed
  /// timestamp that is set when an object is first created.
  public let createdAt: String

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    imageUrl = try reader.value(for: Field(responseName: "imageURL"))
    recipients = try reader.optionalValue(for: Field(responseName: "recipients"))
    createdAt = try reader.value(for: Field(responseName: "createdAt"))
  }

  public struct Recipient: GraphQLMappable {
    public let __typename: String
    /// The set of edges in this page.
    public let edges: [Edge?]?

    public init(reader: GraphQLResultReader) throws {
      __typename = try reader.value(for: Field(responseName: "__typename"))
      edges = try reader.optionalList(for: Field(responseName: "edges"))
    }

    public struct Edge: GraphQLMappable {
      public let __typename: String
      /// The node value for the edge.
      public let node: Node

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        node = try reader.value(for: Field(responseName: "node"))
      }

      public struct Node: GraphQLMappable {
        public let __typename: String

        public let fragments: Fragments

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))

          let completeAddress = try CompleteAddress(reader: reader)
          fragments = Fragments(completeAddress: completeAddress)
        }

        public struct Fragments {
          public let completeAddress: CompleteAddress
        }
      }
    }
  }
}

public struct CompleteUser: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment completeUser on User {" +
    "  __typename" +
    "  id" +
    "  username" +
    "  address {" +
    "    __typename" +
    "    ...completeAddress" +
    "  }" +
    "  remainingPhotos" +
    "  photos {" +
    "    __typename" +
    "    edges {" +
    "      __typename" +
    "      node {" +
    "        __typename" +
    "        ...completePhoto" +
    "      }" +
    "    }" +
    "  }" +
    "}"

  public static let possibleTypes = ["User"]

  public let __typename: String
  /// A globally unique ID.
  public let id: GraphQLID
  /// The user's username.
  public let username: String
  public let address: Address?
  /// The number of photos the user has left before they need to purchase more.
  /// 
  /// Default value of 2 is set on the assumption that when a user creates an account we will want them to have two free photos.
  public let remainingPhotos: Int
  /// The reverse field of 'sender' in 1:M connection
  /// with type 'undefined'.
  public let photos: Photo?

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    username = try reader.value(for: Field(responseName: "username"))
    address = try reader.optionalValue(for: Field(responseName: "address"))
    remainingPhotos = try reader.value(for: Field(responseName: "remainingPhotos"))
    photos = try reader.optionalValue(for: Field(responseName: "photos"))
  }

  public struct Address: GraphQLMappable {
    public let __typename: String

    public let fragments: Fragments

    public init(reader: GraphQLResultReader) throws {
      __typename = try reader.value(for: Field(responseName: "__typename"))

      let completeAddress = try CompleteAddress(reader: reader)
      fragments = Fragments(completeAddress: completeAddress)
    }

    public struct Fragments {
      public let completeAddress: CompleteAddress
    }
  }

  public struct Photo: GraphQLMappable {
    public let __typename: String
    /// The set of edges in this page.
    public let edges: [Edge?]?

    public init(reader: GraphQLResultReader) throws {
      __typename = try reader.value(for: Field(responseName: "__typename"))
      edges = try reader.optionalList(for: Field(responseName: "edges"))
    }

    public struct Edge: GraphQLMappable {
      public let __typename: String
      /// The node value for the edge.
      public let node: Node

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
        node = try reader.value(for: Field(responseName: "node"))
      }

      public struct Node: GraphQLMappable {
        public let __typename: String

        public let fragments: Fragments

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))

          let completePhoto = try CompletePhoto(reader: reader)
          fragments = Fragments(completePhoto: completePhoto)
        }

        public struct Fragments {
          public let completePhoto: CompletePhoto
        }
      }
    }
  }
}

public struct CompleteAddress: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment completeAddress on Address {" +
    "  __typename" +
    "  id" +
    "  primaryLine" +
    "  secondaryLine" +
    "  zipCode" +
    "  name" +
    "  state" +
    "  city" +
    "}"

  public static let possibleTypes = ["Address"]

  public let __typename: String
  /// A globally unique ID.
  public let id: GraphQLID
  public let primaryLine: String
  public let secondaryLine: String?
  public let zipCode: String
  public let name: String
  public let state: String
  public let city: String

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    primaryLine = try reader.value(for: Field(responseName: "primaryLine"))
    secondaryLine = try reader.optionalValue(for: Field(responseName: "secondaryLine"))
    zipCode = try reader.value(for: Field(responseName: "zipCode"))
    name = try reader.value(for: Field(responseName: "name"))
    state = try reader.value(for: Field(responseName: "state"))
    city = try reader.value(for: Field(responseName: "city"))
  }
}
