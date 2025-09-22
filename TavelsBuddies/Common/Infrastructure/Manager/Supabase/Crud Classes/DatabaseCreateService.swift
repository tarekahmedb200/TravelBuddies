//
//  DatabaseCreate.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation

import Foundation
import Supabase

// MARK: - Create Class

class DatabaseCreateService<T: Codable> {
    
    private let supabaseManager: SupabaseManager
    private let tableName: String
    
    init(tableName: String) {
        self.supabaseManager = SupabaseManager()
        self.tableName = tableName
    }
    
    /// Insert a single record
    func create(_ item: T) async throws -> T {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        let response: T = try await client
            .from(tableName)
            .insert(item)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
//    /// Insert multiple records
//    func createBatch(_ items: [T]) async throws -> [T] {
//        guard let client = supabaseManager.getClient() else {
//            throw SupabaseDatabaseError.clientNotAvailable
//        }
//        
//        let response: [T] = try await client
//            .from(tableName)
//            .insert(items)
//            .select()
//            .execute()
//            .value
//        
//        return response
//    }
}


