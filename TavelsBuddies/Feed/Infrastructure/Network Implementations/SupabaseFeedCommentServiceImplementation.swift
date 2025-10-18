//
//  SupabaseFeedCommentServiceImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation


class SupabaseFeedCommentServiceImplementation {
    
    private let databaseCreate: DatabaseCreateService
    private let databaseGet: DatabaseGetService
    private let databaseDelete: DatabaseDeleteService
    private let databaseUpdate: DatabaseUpdateService
    private let newlyInsertedDataObserver: NewlyInsertedDataObserver
    
    private let feedTableName = SupabaseTableNames.feed.rawValue
    private let feedLikeTableName = SupabaseTableNames.feedLike.rawValue
    private let feedCommentTableName = SupabaseTableNames.feedComment.rawValue
    
    init() {
        databaseCreate = DatabaseCreateService()
        databaseGet = DatabaseGetService()
        databaseDelete = DatabaseDeleteService()
        databaseUpdate = DatabaseUpdateService()
        newlyInsertedDataObserver = NewlyInsertedDataObserver()
    }
}


extension SupabaseFeedCommentServiceImplementation: FeedCommentService {
   
    func getSingleFeedComment(feedCommentID: UUID) async throws -> FeedCommentDto? {
        try await databaseGet.getSingle(tableName: feedCommentTableName,
                                        conditionsWithSingleValue: [
                                            FeedCommentDto.CodingKeys.id.rawValue: feedCommentID
                                        ])
    }
    
    func getFeedComments(feedID: UUID) async throws -> [FeedCommentDto] {
        try await databaseGet.getArray(tableName: feedCommentTableName,conditionsWithSingleValue: [
            FeedCommentDto.CodingKeys.feedID.rawValue: feedID
        ])
    }
    
    func createFeedComment(feedCommentDto: FeedCommentDto) async throws {
        try await databaseCreate.create(feedCommentDto, tableName: feedCommentTableName)
    }
    
    
    func updateFeedComment(feedCommentDto: FeedCommentDto) async throws {
        try await databaseUpdate.update(tableName: feedCommentTableName,
                                        with: feedCommentDto,
                                        conditions: [
                                            FeedCommentDto.CodingKeys.id.rawValue: feedCommentDto.id
                                        ])
    }
    
    func deleteFeedComment(feedCommentID: UUID) async throws {
        try await databaseDelete.delete(tableName: feedCommentTableName,
                                        conditions: [
                                            FeedCommentDto.CodingKeys.feedID.rawValue: feedCommentID
                                        ])
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
