//
//  Persister.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import YapDatabase
import RCSYapDatabaseExtensions

typealias SaveAddressResult = Result<Void, AddressError>
typealias SaveAddressCompletion = (SaveAddressResult) -> Void

class  DatabaseController {
    
    static let sharedInstance = DatabaseController(path: DatabaseController.pathForDatabase(named: Database.addressDatabase.rawValue))
    
    enum Database: String {
        case addressDatabase
    }
    
    var yapDatabase: YapDatabase
    
    init(path: String) {
        yapDatabase = YapDatabase(path: path)
    }
    
    func newReadingConnection() -> YapDatabaseConnection {
        let connection = yapDatabase.newConnection()
        connection.beginLongLivedReadTransaction()
        return connection
    }
    
    func newWritingConnection() -> YapDatabaseConnection {
        return yapDatabase.newConnection()
    }
    
    class func pathForDatabase(named name: String) -> String {
        let fm = FileManager()
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        guard let appSupportPath = paths.first else { fatalError() }
        if !fm.fileExists(atPath: appSupportPath) {
            do {
                try fm.createDirectory(atPath: appSupportPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                assertionFailure("unable to create database directory")
            }
        }
        return YapDB.pathToDatabase(.applicationSupportDirectory, name: name)
    }
}
