//
//  SupabaseFeedServiceImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation


class SupabaseFeedServiceImplementation {
    
    private let databaseCreate: DatabaseCreateService
    private let databaseGet: DatabaseGetService
    private let databaseDelete: DatabaseDeleteService
    private let databaseUpdate: DatabaseUpdateService
    private let supabaseDataObserver: SupabaseDataObserver
    
    private let feedTableName = SupabaseTableNames.feed.rawValue
    private let feedLikeTableName = SupabaseTableNames.feedLike.rawValue
    private let feedCommentTableName = SupabaseTableNames.feedComment.rawValue
    
    init() {
        databaseCreate = DatabaseCreateService()
        databaseGet = DatabaseGetService()
        databaseDelete = DatabaseDeleteService()
        databaseUpdate = DatabaseUpdateService()
        supabaseDataObserver = SupabaseDataObserver()
    }
}


extension SupabaseFeedServiceImplementation: FeedService {
    func getSingleFeed(feedId: UUID) async throws -> FeedDto? {
        try await databaseGet.getSingle(tableName: feedTableName,conditionsWithSingleValue: [
            FeedDto.CodingKeys.id.rawValue : feedId
        ])
    }
    
    func createFeed(feed: FeedDto) async throws {
        try await databaseCreate.create(feed, tableName: feedTableName)
    }
    
    func updateFeed(feedDto: FeedDto) async throws {
        try await databaseUpdate.update(tableName: feedTableName,
                              with: feedDto,
                              conditions: [
                                FeedDto.CodingKeys.id.rawValue : feedDto.id
                              ] )
    }
    
    func deleteFeed(feedID: UUID) async throws {
        try await databaseDelete.delete(tableName: feedTableName,
                              conditions: [
                                FeedDto.CodingKeys.id.rawValue : feedID
                              ])
    }
    
    func getAllFeeds() async throws -> [FeedDto] {
        try await databaseGet.getArray(tableName: feedTableName)
    }
    
 
    func observeFeedChanges() -> AsyncStream<(FeedDto,CrudObservationOperationType)> {
        let stream = supabaseDataObserver.start(tableName: feedTableName)
        return AsyncStream { continuation in
            Task {
                for await (feedJson,crudType) in stream {
                    do {
                        let feedDto = try FeedDto.from(dictionary: feedJson)
                        continuation.yield((feedDto,crudType))
                    } catch {
                        print("Decode error:", error)
                    }
                }
                continuation.finish()
            }
        }
    }
    
}
