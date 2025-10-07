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
    
   
    func getSingle<T: Codable>(
        tableName: String,
        conditionsWithSingleValue: [String: PostgrestFilterValue] = [:],
        conditionsWithMutipleValues: [String: [PostgrestFilterValue]] = [:]
    ) async throws -> T? {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        var query = client.from(tableName).select()
        
        for (column, value) in conditionsWithSingleValue {
            query = query.eq(column, value: value)
        }
        
        for (column, values) in conditionsWithMutipleValues {
            query = query.in(column, values: values)
        }
        
        do {
            let response: T? = try await query
                .single()
                .execute()
                .value
            
            return response
        } catch {
            return nil
        }
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
