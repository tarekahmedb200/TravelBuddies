//
//  NewlyInsertedDataObserver.swift
//  TravelBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation
import Supabase

final class NewlyInsertedDataObserver {
    
    private let supabaseManager: SupabaseManager
    private var channel: RealtimeChannelV2?
    
    
    init(tableName: String) {
        self.supabaseManager = SupabaseManager()
    }
    
    deinit {
        print("helllo deinit")
        stop()
    }
    
    /// Start observing inserted rows for the given table.
    func start(tableName: String) -> AsyncStream<[String: Any]> {
        AsyncStream { [weak self] continuation in
            
            guard let weakSelf = self else {
                continuation.finish()
                return
            }
            
            guard let client = weakSelf.supabaseManager.getClient() else {
                continuation.finish()
                return
            }
            
            let channel = client.channel("\(tableName)")
            weakSelf.channel = channel
            
            let changeStream = channel.postgresChange(
                AnyAction.self,
                schema: "public",
                table: tableName
            )
            
            Task {
                do {
                    try await channel.subscribeWithError()
                    
                    for try await change in changeStream {
                        switch change {
                        case .insert(let action):
                            continuation.yield(action.record)
                        default:
                            break
                        }
                    }
                    
                } catch {
                    continuation.finish()
                }
            }
            
            continuation.onTermination = { @Sendable _ in
                Task {
                    await channel.unsubscribe()
                }
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
