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
    private let newlyInsertedDataObserver: NewlyInsertedDataObserver
    
    private let feedTableName = SupabaseTableNames.feed.rawValue
    private let feedLikeTableName = SupabaseTableNames.feedLike.rawValue
    private let feedCommentTableName = SupabaseTableNames.feedComment.rawValue
    
    init() {
        databaseCreate = DatabaseCreateService()
        databaseGet = DatabaseGetService()
        databaseDelete = DatabaseDeleteService()
        newlyInsertedDataObserver = NewlyInsertedDataObserver()
    }
}


extension SupabaseFeedServiceImplementation: FeedService {
   
    func createFeed(feed: FeedDto) async throws {
        try await databaseCreate.create(feed, tableName: feedTableName)
    }
    
    func getAllFeeds() async throws -> [FeedDto] {
        try await databaseGet.getArray(tableName: feedTableName)
    }
    
    func getFeedComments(feedID: UUID) async throws -> [FeedCommentDto] {
        try await databaseGet.getArray(tableName: feedCommentTableName,conditionsWithSingleValue: [
            FeedCommentDto.CodingKeys.feedID.rawValue: feedID
        ])
    }
    
    func createFeedComment(feedCommentDto: FeedCommentDto) async throws {
        try await databaseCreate.create(feedCommentDto, tableName: feedCommentTableName)
    }
    
    func getFeedsLikes(feedIDs: [UUID]) async throws -> [FeedLikeDto] {
        try await databaseGet.getArray(tableName: feedCommentTableName,conditionsWithMutipleValues: [
            FeedCommentDto.CodingKeys.feedID.rawValue: feedIDs
        ])
    }
    
    func getAllFeedMedia(mediaType: MediaType, feedID: UUID) async throws -> [Data] {
        return [Data()]
    }
    
    func likeFeed(feedLikeDto: FeedLikeDto) async throws {
        try await databaseCreate.create(feedLikeDto, tableName: feedLikeTableName)
    }
    
    func unlikeFeed(feedID : UUID , profileID : UUID) async throws {
        try await databaseDelete.delete(
            tableName: feedLikeTableName, conditions:
                [
                    FeedLikeDto.CodingKeys.feedID.rawValue: feedID,
                    FeedLikeDto.CodingKeys.profileID.rawValue : profileID
                ]
        )
    }
    
    func observeNewlyAddedFeedChanges() -> AsyncStream<FeedDto> {
        let stream = newlyInsertedDataObserver.start(tableName: feedTableName)
        return AsyncStream { continuation in
            Task {
                for await feedJson in stream {
                    do {
                        let feedDto = try FeedDto.from(dictionary: feedJson)
                        continuation.yield(feedDto)
                    } catch {
                        print("Decode error:", error)
                    }
                }
                continuation.finish()
            }
        }
    }
    
    func observeNewlyAddedFeedCommentsChanges() -> AsyncStream<FeedCommentDto> {
        let stream = newlyInsertedDataObserver.start(tableName: feedCommentTableName)
        return AsyncStream { continuation in
            Task {
                for await feedCommentJson in stream {
                    do {
                        let feedCommentDto = try FeedCommentDto.from(dictionary: feedCommentJson)
                        continuation.yield(feedCommentDto)
                    } catch {
                        print("Decode error:", error)
                    }
                }
                continuation.finish()
            }
        }
    }

    
}
