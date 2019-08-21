//
//  Formatter+Extensions.swift
//  Informer
//
//  Created by Александр on 24.02.18.
//  Copyright © 2018 Александр. All rights reserved.
//

import Foundation

class ISO8601Formatter: DateFormatter {
    
    static let formatters: [DateFormatter] = [
        iso8601Formatter(withFractional: true),
        iso8601Formatter(withFractional: false)
    ]
    
    static func iso8601Formatter(withFractional fractional: Bool) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss\(fractional ? ".SSS" : "")XXXXX"
        return formatter
    }
    
    override public func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
                                        for string: String,
                                        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        guard let date = (type(of: self).formatters.compactMap { $0.date(from: string) }).first else {
            error?.pointee = "Invalid ISO8601 date: \(string)" as NSString
            return false
        }
        obj?.pointee = date as NSDate
        return true
    }
    
    override public func string(for obj: Any?) -> String? {
        guard let date = obj as? Date else { return nil }
        return type(of: self).formatters.compactMap { $0.string(from: date) }.first
    }
}

