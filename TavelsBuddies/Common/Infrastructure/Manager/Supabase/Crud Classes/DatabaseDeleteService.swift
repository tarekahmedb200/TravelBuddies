//
//  DatabaseDelete.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation
import Supabase


class DatabaseDeleteService<T: Codable> {
    
    private let supabaseManager: SupabaseManager
    private let tableName: String
    
    init(tableName: String) {
        self.supabaseManager = SupabaseManager()
        self.tableName = tableName
    }
    
    /// Delete record by ID
    func delete(with id: String,and idColumn: String = "id") async throws -> T {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        let response: T = try await client
            .from(tableName)
            .delete()
            .eq(idColumn, value: id)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
//    /// Delete records with filter
//    func deleteWhere(_ filter: String) async throws -> [T] {
//        guard let client = supabaseManager.getClient() else {
//            throw SupabaseDatabaseError.clientNotAvailable
//        }
//        
//        let response: [T] = try await client
//            .from(tableName)
//            .delete()
//            .eq(filter)
//            .select()
//            .execute()
//            .value
//        
//        return response
//    }
}
