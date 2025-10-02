//
//  DatabaseRead.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation
import Supabase


class DatabaseGetService {
    
    private let supabaseManager: SupabaseManager
    
    init() {
        self.supabaseManager = SupabaseManager()
    }
    
   
    func getSingle<T: Codable>(tableName: String,id: UUID,idColumnName: String = "id") async throws -> T {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        let response: T = try await client
            .from(tableName)
            .select()
            .eq(idColumnName, value: id)
            .single()
            .execute()
            .value
        
        return response
    }
    
    
    func getArray<T: Codable>(
        tableName: String,
        conditionsWithSingleValue: [String: PostgrestFilterValue] = [:],
        conditionsWithMutipleValues: [String: [PostgrestFilterValue]] = [:]
    ) async throws -> T {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        var query = client.from(tableName).select()
        
        // Apply all conditions dynamically
        for (column, value) in conditionsWithSingleValue {
            query = query.eq(column, value: value )
        }
        
        for (column, value) in conditionsWithMutipleValues {
            query = query.in(column, values: value )
        }
        
        let response: T = try await query
            .execute()
            .value
        
        return response
    }

    
    
    
    
    
}
