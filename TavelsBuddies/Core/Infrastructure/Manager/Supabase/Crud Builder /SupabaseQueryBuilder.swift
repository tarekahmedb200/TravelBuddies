//
//  SupabaseQueryBuilder.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation
import Supabase

final class SupabaseQueryBuilder {
    
    private let client: SupabaseClient
    private let tableName: String
    private var query: PostgrestFilterBuilder
    
    init(client: SupabaseClient, tableName: String) {
        self.client = client
        self.tableName = tableName
        self.query = client.from(tableName).select()
    }
    
    // MARK: - Generic Filters
    
    @discardableResult
    func byEqual<T: PostgrestFilterValue>(_ column: String, value: T) -> SupabaseQueryBuilder {
        query = query.eq(column, value: value)
        return self
    }
    
    @discardableResult
    func byNotEqual<T: PostgrestFilterValue>(_ column: String, value: T) -> SupabaseQueryBuilder {
        query = query.neq(column, value: value)
        return self
    }
    
    @discardableResult
    func byRange<T: PostgrestFilterValue>(_ column: String, range: ClosedRange<T>) -> SupabaseQueryBuilder {
        query = query.gte(column, value: range.lowerBound)
        query = query.lte(column, value: range.upperBound)
        return self
    }
    
    @discardableResult
    func byGreaterOrEqual<T: PostgrestFilterValue>(_ column: String, value: T) -> SupabaseQueryBuilder {
        query = query.gte(column, value: value)
        return self
    }
    
    @discardableResult
    func byLessOrEqual<T: PostgrestFilterValue>(_ column: String, value: T) -> SupabaseQueryBuilder {
        query = query.lte(column, value: value)
        return self
    }
    
    @discardableResult
    func byArrayContains<T: PostgrestFilterValue>(_ column: String, values: [T]) -> SupabaseQueryBuilder {
        query = query.contains(column, value: values)
        return self
    }
    
    @discardableResult
    func byLike(_ column: String, pattern: String) -> SupabaseQueryBuilder {
        query = query.like(column, pattern: pattern)
        return self
    }
    
    @discardableResult
    func byBool(_ column: String, value: Bool) -> SupabaseQueryBuilder {
        query = query.eq(column, value: value)
        return self
    }
    
    // MARK: - Other Utilities
    
    @discardableResult
    func orderBy(_ column: String, ascending: Bool = true) -> SupabaseQueryBuilder {
        query = query.order(column, ascending: ascending) as! PostgrestFilterBuilder
        return self
    }
    
    func build() -> PostgrestFilterBuilder {
        return query
    }
    
    func execute<T: Decodable>() async throws -> [T] {
        return try await query.execute().value
    }
}
