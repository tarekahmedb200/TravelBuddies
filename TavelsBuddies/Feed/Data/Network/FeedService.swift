//
//  FeedService.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation

protocol FeedService {
    func createFeed(feed: FeedDto) async throws
    func getAllFeeds() async throws -> [FeedDto]
    func getFeedComments(feedID: UUID) async throws -> [FeedCommentDto]
    func createFeedComment(feedCommentDto: FeedCommentDto) async throws
    func getFeedsLikes(feedIDs: [UUID]) async throws -> [FeedLikeDto]
    func getAllFeedMedia(mediaType: MediaType,feedID :UUID) async throws -> [Data]
    func likeFeed(feedLikeDto: FeedLikeDto) async throws
    func unlikeFeed(feedID :UUID,profileID : UUID) async throws
    
    func observeNewlyAddedFeedChanges() -> AsyncStream<FeedDto>
    func observeNewlyAddedFeedCommentsChanges() -> AsyncStream<FeedCommentDto>
}
