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
    
    
    func update<T: Codable>(
        tableName: String,
        with item: T,
        conditions: [String: PostgrestFilterValue] = [:]
    ) async throws {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        var query = try client
            .from(tableName)
            .update(item)
        
        // Apply all conditions dynamically
        for (column, value) in conditions {
            query = query.eq(column, value: value)
        }
        
        try await query.execute()
    }
    
}
