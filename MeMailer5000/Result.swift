//
//  Result.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/4/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

public enum Result<V, E: Error> {
    public typealias Value = V
    
    /**
     The process completed successfully, and a value is available.
     */
    case success(Value)
    
    /**
     The process failed, and an error (like `NSError`) is available.
     */
    case error(E)
}
