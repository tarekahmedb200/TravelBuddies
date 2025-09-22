//
//  DatabaseRead.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation
import Supabase


class DatabaseGetService<T: Codable> {
    
    private let supabaseManager: SupabaseManager
    private let tableName: String
    
    init(tableName: String) {
        self.supabaseManager = SupabaseManager()
        self.tableName = tableName
    }
    
    /// Fetch all records
    func getAll() async throws -> [T] {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        let response: [T] = try await client
            .from(tableName)
            .select()
            .execute()
            .value
        
        return response
    }
    
    /// Fetch single record by ID
    func get(with id: String,and idColumn: String = "id") async throws -> T {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        let response: T = try await client
            .from(tableName)
            .select()
            .eq(idColumn, value: id)
            .single()
            .execute()
            .value
        
        return response
    }
}
