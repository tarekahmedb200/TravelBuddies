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
    
    /// Fetch all records
    func getAll<T: Codable>(tableName: String) async throws -> [T] {
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
    
    func getAll<T: Codable>(
        tableName: String,
        ids: [UUID],
        idColumnName: String = "id"
    ) async throws -> [T] {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        let response: [T] = try await client
            .from(tableName)
            .select()
            .in(idColumnName, values: ids)
            .execute()
            .value
        
        return response
    }
    
    func get<T: Codable>(tableName: String,id: UUID,idColumnName: String = "id") async throws -> T {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        let response: T = try await client
            .from(tableName)
            .select()
            .eq(idColumnName, value: id)
            .execute()
            .value
        
        return response
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
    
    
    func get<T: Codable>(
        tableName: String,
        conditions: [String: Any]
    ) async throws -> T {
        guard let client = supabaseManager.getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        var query = client.from(tableName).select()
        
        // Apply all conditions dynamically
        for (column, value) in conditions {
            query = query.eq(column, value: value as! PostgrestFilterValue)
        }
        
        let response: T = try await query
            .single()
            .execute()
            .value
        
        return response
    }

    
    
    
    
    
}
