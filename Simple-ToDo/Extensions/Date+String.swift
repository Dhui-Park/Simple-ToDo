//
//  Date+String.swift
//  Simple-ToDo
//
//  Created by dhui on 2023/09/25.
//

import Foundation
import UIKit

extension Date {
    
    
    /// Date -> String
    /// - Returns: String
    func makeDateString(format: String = "yyyy-MM-dd'T'HH:mm:ssZZZZZ") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "KST")
        
        return formatter.string(from: self)
    }
    
    
    /// String -> Date
    /// - Parameters:
    ///   - dateString:
    ///   - format:
    /// - Returns: Date?
    static func makeString(from dateString: String, format: String = "yyyy-MM-dd'T'HH:mm:ssZZZZZ") -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: "KST")
        
        return formatter.date(from: dateString)
    }
    
}
