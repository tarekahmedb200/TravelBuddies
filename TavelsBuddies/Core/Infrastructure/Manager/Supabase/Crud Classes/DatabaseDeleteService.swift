//
//  DatabaseDeleteService.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation
import Supabase

class DatabaseDeleteService {
    
    private let supabaseManager: SupabaseManager
    
    init() {
        self.supabaseManager = SupabaseManager()
    }
    
    /// Delete a single record by ID
    func deleteById(
        tableName: String,
        id: UUID,
        idColumnName: String = "id"
    ) async throws {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        _ = try await client
            .from(tableName)
            .delete()
            .eq(idColumnName, value: id)
            .execute()
    }
    
    /// Delete records by condition (e.g., all by feedID)
    func deleteWhere(
        tableName: String,
        columnName: String,
        value: Any
    ) async throws {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        _ = try await client
            .from(tableName)
            .delete()
            .eq(columnName, value: value as! PostgrestFilterValue)
            .execute()
    }
    

    func delete(
        tableName: String,
        filters: [String: Any]
    ) async throws {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }

        var query = client.from(tableName).delete()

        // Apply filters dynamically from the dictionary
        for (column, value) in filters {
            query = query.eq(column, value: value as! PostgrestFilterValue)
        }

        _ = try await query.execute()
    }

}
