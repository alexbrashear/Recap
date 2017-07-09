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

  public init(user: CreateUserInput? = nil, userId: GraphQLID? = nil, secondaryLine: String? = nil, name: String, primaryLine: String, zipCode: String, state: String, clientMutationId: GraphQLID? = nil) {
    graphQLMap = ["user": user, "userId": userId, "secondaryLine": secondaryLine, "name": name, "primaryLine": primaryLine, "zipCode": zipCode, "state": state, "clientMutationId": clientMutationId]
  }
}

public final class CreateUserMutMutation: GraphQLMutation {
  public static let operationDefinition =
    "mutation CreateUserMut($user: CreateUserInput!) {" +
    "  createUser(input: $user) {" +
    "    __typename" +
    "    changedUser {" +
    "      __typename" +
    "      id" +
    "      username" +
    "      address {" +
    "        __typename" +
    "        name" +
    "        primaryLine" +
    "        secondaryLine" +
    "        state" +
    "        zipCode" +
    "      }" +
    "    }" +
    "  }" +
    "}"

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
        /// A globally unique ID.
        public let id: GraphQLID
        /// The user's username.
        public let username: String
        public let address: Address?

        public init(reader: GraphQLResultReader) throws {
          __typename = try reader.value(for: Field(responseName: "__typename"))
          id = try reader.value(for: Field(responseName: "id"))
          username = try reader.value(for: Field(responseName: "username"))
          address = try reader.optionalValue(for: Field(responseName: "address"))
        }

        public struct Address: GraphQLMappable {
          public let __typename: String
          public let name: String
          public let primaryLine: String
          public let secondaryLine: String?
          public let state: String
          public let zipCode: String

          public init(reader: GraphQLResultReader) throws {
            __typename = try reader.value(for: Field(responseName: "__typename"))
            name = try reader.value(for: Field(responseName: "name"))
            primaryLine = try reader.value(for: Field(responseName: "primaryLine"))
            secondaryLine = try reader.optionalValue(for: Field(responseName: "secondaryLine"))
            state = try reader.value(for: Field(responseName: "state"))
            zipCode = try reader.value(for: Field(responseName: "zipCode"))
          }
        }
      }
    }
  }
}