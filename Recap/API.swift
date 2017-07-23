//  This file was automatically generated and should not be edited.

import Apollo

public struct CreateUserInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  public init(username: String, address: CreateAddressInput? = nil, addressId: GraphQLID? = nil, password: String, clientMutationId: GraphQLID? = nil) {
    graphQLMap = ["username": username, "address": address, "addressId": addressId, "password": password, "clientMutationId": clientMutationId]
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

public final class SignupUserMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation SignupUser($user: CreateUserInput!) {" +
    "  createUser(input: $user) {" +
    "    __typename" +
    "    changedUser {" +
    "      __typename" +
    "      ...completeUser" +
    "    }" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(CompleteUser.fragmentDefinition).appending(CompleteAddress.fragmentDefinition)

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

public final class LoginUserMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation LoginUser($input: LoginUserInput!) {" +
    "  loginUser(input: $input) {" +
    "    __typename" +
    "    user {" +
    "      __typename" +
    "      ...completeUser" +
    "    }" +
    "  }" +
    "}"
  public static let queryDocument = operationDefinition.appending(CompleteUser.fragmentDefinition).appending(CompleteAddress.fragmentDefinition)

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
      /// The mutated User.
      public let user: User?

      public init(reader: GraphQLResultReader) throws {
        __typename = try reader.value(for: Field(responseName: "__typename"))
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

public struct CompleteUser: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment completeUser on User {" +
    "  __typename" +
    "  username" +
    "  address {" +
    "    __typename" +
    "    ...completeAddress" +
    "  }" +
    "}"

  public static let possibleTypes = ["User"]

  public let __typename: String
  /// The user's username.
  public let username: String
  public let address: Address?

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    username = try reader.value(for: Field(responseName: "username"))
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

public struct CompleteAddress: GraphQLNamedFragment {
  public static let fragmentDefinition =
    "fragment completeAddress on Address {" +
    "  __typename" +
    "  primaryLine" +
    "  secondaryLine" +
    "  zipCode" +
    "  name" +
    "  state" +
    "  city" +
    "}"

  public static let possibleTypes = ["Address"]

  public let __typename: String
  public let primaryLine: String
  public let secondaryLine: String?
  public let zipCode: String
  public let name: String
  public let state: String
  public let city: String

  public init(reader: GraphQLResultReader) throws {
    __typename = try reader.value(for: Field(responseName: "__typename"))
    primaryLine = try reader.value(for: Field(responseName: "primaryLine"))
    secondaryLine = try reader.optionalValue(for: Field(responseName: "secondaryLine"))
    zipCode = try reader.value(for: Field(responseName: "zipCode"))
    name = try reader.value(for: Field(responseName: "name"))
    state = try reader.value(for: Field(responseName: "state"))
    city = try reader.value(for: Field(responseName: "city"))
  }
}