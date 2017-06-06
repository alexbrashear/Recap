//
//  Date+Formatting.swift
//  Recap
//
//  Created by Alex Brashear on 3/19/17.
//  Copyright © 2017 memailer. All rights reserved.
//

import Foundation

extension Date {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    
    static let basicFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let displayableFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy"
        return formatter
    }()
    
    var filmPurchaseDateString: String {
        return Date.displayableFormatter.string(from: self)
    }
    
    var displayableDate: String {
        let dateString = Date.basicFormatter.string(from: self)
        let dateComponents = dateString.components(separatedBy: "-")
        guard let monthInt = Int(dateComponents[1] as String) else { return "" }
        let day = dateComponents[2] as String
        let month = Month.month(forNumber: monthInt)
        guard month != .none else { return "" }
        return "Expected to arrive \(month.rawValue.capitalized) \(day)"
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}

fileprivate enum Month: String {
    case january
    case february
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    case none
    
    static func month(forNumber number: Int) -> Month {
        switch number {
        case 1: return .january
        case 2: return .february
        case 3: return .march
        case 4: return .april
        case 5: return .may
        case 6: return .june
        case 7: return .july
        case 8: return .august
        case 9: return .september
        case 10: return .october
        case 11: return .november
        case 12: return .december
        default: return .none
        }
    }
}
