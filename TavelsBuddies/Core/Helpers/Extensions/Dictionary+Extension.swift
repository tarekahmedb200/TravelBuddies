//
//  Dictionary+Extension.swift
//  TavelsBuddies
//
//  Created by tarek on 27/09/2025.
//

import Foundation
import Supabase

extension Dictionary where Key == String, Value == Any {
    func decodeUUID(for key: String) throws -> UUID {
        guard let json = self[key] as? AnyJSON,
              let uuid = UUID(uuidString: json.description) else {
            throw MappingError.invalidOrMissing(key: key)
        }
        return uuid
    }
    
    func decodeString(for key: String) throws -> String {
        guard let json = self[key] as? AnyJSON else {
            throw MappingError.invalidOrMissing(key: key)
        }
        return json.description
    }
    
    func decodeDate(for key: String) throws -> Date {
        guard let json = self[key] as? AnyJSON,
              let date = Date.fromServerISO(json.description) else {
            throw MappingError.invalidOrMissing(key: key)
        }
        return date
    }
}
