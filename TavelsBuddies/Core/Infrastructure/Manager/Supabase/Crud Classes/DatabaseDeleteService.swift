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
    
    func delete(
        tableName: String,
        conditions: [String: PostgrestFilterValue] = [:]
    ) async throws {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }

        var query = client.from(tableName).delete()

        // Apply all conditions dynamically
        for (column, value) in conditions {
            query = query.eq(column, value: value)
        }

        _ = try await query.execute()
    }

}
