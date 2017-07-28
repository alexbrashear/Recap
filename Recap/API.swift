//  This file was automatically generated and should not be edited.

import Apollo

public struct CreatePhotoInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(largeThumbnailUrl: String, expectedDeliveryDate: String, imageUrl: String, mediumThumbnailUrl: String, smallThumbnailUrl: String? = nil, user: CreateUserInput? = nil, userId: GraphQLID? = nil, clientMutationId: GraphQLID? = nil) {
    graphQLMap = ["largeThumbnailURL": largeThumbnailUrl, "expectedDeliveryDate": expectedDeliveryDate, "imageURL": imageUrl, "mediumThumbnailURL": mediumThumbnailUrl, "smallThumbnailURL": smallThumbnailUrl, "user": user, "userId": userId, "clientMutationId": clientMutationId]
  }
}

public struct CreateUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(remainingPhotos: Int, username: String, address: CreateAddressInput? = nil, addressId: GraphQLID? = nil, password: String, clientMutationId: GraphQLID? = nil) {
    graphQLMap = ["remainingPhotos": remainingPhotos, "username": username, "address": address, "addressId": addressId, "password": password, "clientMutationId": clientMutationId]
  }
}

public struct CreateAddressInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(user: CreateUserInput? = nil, userId: GraphQLID? = nil, city: String, secondaryLine: String? = nil, name: String, primaryLine: String, zipCode: String, state: String, clientMutationId: GraphQLID? = nil) {
    graphQLMap = ["user": user, "userId": userId, "city": city, "secondaryLine": secondaryLine, "name": name, "primaryLine": primaryLine, "zipCode": zipCode, "state": state, "clientMutationId": clientMutationId]
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

public final class CreatePhotoMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreatePhoto($input: CreatePhotoInput!) {" +
    "  createPhoto(input: $input) {" +
    "    __typename" +
    "    changedPhoto {" +
    "      __typename" +
    "      ...completePhoto" +
    "    }" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(CompletePhoto.fragmentDefinition)

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

public struct CompletePhoto: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment completePhoto on Photo {" +
    "  __typename" +
    "  id" +
    "  smallThumbnailURL" +
    "  mediumThumbnailURL" +
    "  largeThumbnailURL" +
    "  imageURL" +
    "  createdAt" +
    "  expectedDeliveryDate" +
    "}"

  public static let possibleTypes = ["Photo"]

  public let __typename: String
  /// A globally unique ID.
  public let id: GraphQLID
  public let smallThumbnailUrl: String?
  public let mediumThumbnailUrl: String
  public let largeThumbnailUrl: String
  public let imageUrl: String
  /// When paired with the Node interface, this is an automatically managed
  /// timestamp that is set when an object is first created.
  public let createdAt: String
  public let expectedDeliveryDate: String

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    id = try reader.value(for: Field(responseName: "id"))
    smallThumbnailUrl = try reader.optionalValue(for: Field(responseName: "smallThumbnailURL"))
    mediumThumbnailUrl = try reader.value(for: Field(responseName: "mediumThumbnailURL"))
    largeThumbnailUrl = try reader.value(for: Field(responseName: "largeThumbnailURL"))
    imageUrl = try reader.value(for: Field(responseName: "imageURL"))
    createdAt = try reader.value(for: Field(responseName: "createdAt"))
    expectedDeliveryDate = try reader.value(for: Field(responseName: "expectedDeliveryDate"))
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
  /// The number of photos the User has left.
  public let remainingPhotos: Int
  /// A collection of Photos the user has sent.
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