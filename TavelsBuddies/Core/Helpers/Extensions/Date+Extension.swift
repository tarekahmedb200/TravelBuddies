//
//  Date+Extension.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation

extension Date {
    /// Formats the date into a string with a given format
    func toString(format: String = "yyyy-MM-dd HH:mm aa") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    //2025-09-27T20:14:23.498
    
    static func fromServerISO(_ string: String) -> Date? {
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXX",  // 2025-09-27T19:22:41.566+00:00
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",    // 2025-09-27T19:22:41.566+0000
            "yyyy-MM-dd'T'HH:mm:ssXXX",      // without fractional seconds + timezone
            "yyyy-MM-dd'T'HH:mm:ssZ",        // without fractional seconds + UTC offset
            "yyyy-MM-dd HH:mm:ss.SS",        // 2025-09-27 20:04:51.67
            "yyyy-MM-dd'T'HH:mm:ss.SSS"      // ✅ 2025-09-27T20:14:23.498
        ]
        
        for format in formats {
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.timeZone = TimeZone(secondsFromGMT: 0)
            df.dateFormat = format
            if let d = df.date(from: string) {
                return d
            }
        }
        return nil
    }
    
    /// Convenience that throws for use in `guard let` style code
    static func fromServerISOOrThrow(_ string: String) throws -> Date {
        if let d = fromServerISO(string) { return d }
        throw MappingError.invalidOrMissing(key: "created_at")
    }
}

