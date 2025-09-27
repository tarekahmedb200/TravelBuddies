//
//  DatabaseUpdate.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation
import Supabase

class DatabaseUpdateService {
    
    private let supabaseManager: SupabaseManager
   
    init() {
        self.supabaseManager = SupabaseManager()
    }
    
    func update<T: Codable>(tableName: String,with id: UUID, and item: T,and idColumn: String = "id") async throws -> T {
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
