//
//  SupabaseFeedLikeServiceImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation


class SupabaseFeedLikeServiceImplementation {
    
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


extension SupabaseFeedLikeServiceImplementation: FeedLikeService {
   
    func getFeedsLikes(feedIDs: [UUID]) async throws -> [FeedLikeDto] {
        try await databaseGet.getArray(tableName: feedCommentTableName,conditionsWithMutipleValues: [
            FeedCommentDto.CodingKeys.feedID.rawValue: feedIDs
        ])
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
    
}
