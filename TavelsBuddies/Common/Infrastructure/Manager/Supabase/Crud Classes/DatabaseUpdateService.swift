//
//  DatabaseUpdate.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation
import Supabase

class DatabaseUpdateService<T: Codable> {
    
    private let supabaseManager: SupabaseManager
    private let tableName: String
    
    init(tableName: String) {
        self.supabaseManager = SupabaseManager()
        self.tableName = tableName
    }
    
    func update(with id: String, and item: T,and idColumn: String = "id") async throws -> T {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        let response: T = try await client
            .from(tableName)
            .update(item)
            .eq(idColumn, value: id)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
//    /// Update records with filter
//    func updateWhere(_ item: T, filter: String) async throws -> [T] {
//        guard let client = supabaseManager.getClient() else {
//            throw SupabaseDatabaseError.clientNotAvailable
//        }
//        
//        let response: [T] = try await client
//            .from(tableName)
//            .update(item)
//          //  .eq(filter, value: <#any PostgrestFilterValue#>)
//            .select()
//            .execute()
//            .value
//        
//        return response
//    }
}
