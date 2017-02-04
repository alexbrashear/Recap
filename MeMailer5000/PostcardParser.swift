//
//  PostcardParser.swift
//  MeMailer5000
//
//  Created by Alex Brashear on 2/1/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

struct PostcardParser {
//    private let addressParser = AddressParser()
//    func parse(json: [String:AnyObject]) {
//        guard let toAddress = json["to"],
//              let 
//    }
    
    func expectedDeliveryDate(json: [String:AnyObject]) -> String {
        guard let date = json["expected_delivery_date"] as? String else { return "" }
        return date
    }
}
