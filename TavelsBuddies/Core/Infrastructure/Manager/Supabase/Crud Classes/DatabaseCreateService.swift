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

class DatabaseCreateService {
    
    private let supabaseManager: SupabaseManager
 
    init() {
        self.supabaseManager = SupabaseManager()
    }
    
    /// Insert a single record
    func create<T : Codable>(_ item: T,tableName: String) async throws -> T {
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
    

}


