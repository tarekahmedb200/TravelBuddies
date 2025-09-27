//
//  FeedRepository.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation

protocol FeedRepository {
    func createFeed(feed: Feed) async throws
    func getAllFeeds() async throws -> [Feed]
    func getFeedComments(feedID: UUID) async throws -> [FeedComment]
    func createFeedComment(feedComment: FeedComment) async throws
    func getFeedsLikes(feedIDs: [UUID]) async throws -> [FeedLike]
    func getAllFeedMedia(mediaType: MediaType,feedID :UUID) async throws -> [Data]
    func observeNewlyAddedFeedChanges() -> AsyncStream<Feed>
    func observeNewlyAddedFeedCommentsChanges() -> AsyncStream<FeedComment>
    func likeFeed(feedID : UUID) async throws
    func unlikeFeed(feedID : UUID) async throws
}
