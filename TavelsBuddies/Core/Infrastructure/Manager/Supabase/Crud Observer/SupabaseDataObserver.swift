//
//  SupabaseDataObserver.swift
//  TravelBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation
import Supabase

final class SupabaseDataObserver {
    
    private let supabaseManager: SupabaseManager
    private var channel: RealtimeChannelV2?
    
    
    init() {
        self.supabaseManager = SupabaseManager()
    }
    
    deinit {
        print("helllo deinit")
        stop()
    }
    
    /// Start observing inserted rows for the given table.
    func start(tableName: String) -> AsyncStream<([String: Any],CrudObservationOperationType)> {
        makeStream(tableName: tableName, filter: nil)
    }
    
    /// Start observing inserted rows for the given table with a filter.
    func start(tableName: String, columnName: String, value: UUID) -> AsyncStream<([String: Any],CrudObservationOperationType)> {
        makeStream(tableName: tableName, filter: .eq(columnName, value: value))
    }
    
    /// Shared implementation
    private func makeStream(
        tableName: String,
        filter: RealtimePostgresFilter?
    ) -> AsyncStream<([String: Any],CrudObservationOperationType)> {
        AsyncStream { [weak self] continuation in
            guard let self,
                  let client = self.supabaseManager.getClient() else {
                continuation.finish()
                return
            }
            
            let channel = client.channel(tableName)
            self.channel = channel
            
            // Apply filter if provided
            let changeStream = channel.postgresChange(
                AnyAction.self,
                schema: "public",
                table: tableName,
                filter: filter
            )
            
            Task {
                do {
                    try await channel.subscribeWithError()
                    
                    for try await change in changeStream {
                        
                        switch change {
                        case .insert(let action):
                            continuation.yield((action.record, .insert))
                        case .update(let action):
                            continuation.yield((action.record, .update))
                        case .delete(let action):
                            continuation.yield((action.oldRecord, .delete))
                        }
                    }
                } catch {
                    continuation.finish()
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                Task { await channel.unsubscribe() }
            }
        }
    }
    
    
    func stop() {
        Task { [weak self] in
            guard let weakSelf = self else { return }
            
            await weakSelf.channel?.unsubscribe()
            weakSelf.channel = nil
        }
    }
}

enum ObserverError: Error {
    case clientNotAvailable
}
