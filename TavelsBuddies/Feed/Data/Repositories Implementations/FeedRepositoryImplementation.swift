//
//  FeedRepositoryImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation


class FeedRepositoryImplementation {
    private let feedService: FeedService
    private let authenticationService: AuthenticationService
    
    init(feedService: FeedService, authenticationService: AuthenticationService) {
        self.feedService = feedService
        self.authenticationService = authenticationService
    }
}

extension FeedRepositoryImplementation: FeedRepository {
    
    
    func createFeed(feed: Feed) async throws {
        try await feedService.createFeed(feed: feed.toDto())
    }
    
    func getAllFeeds() async throws -> [Feed] {
        let feeds = try await feedService.getAllFeeds()
        return feeds.map {
            return $0.toDomain()
        }
    }
    
    func getFeedComments(feedID: UUID) async throws -> [FeedComment] {
        try await feedService.getFeedComments(feedID: feedID).map {
            return $0.toDomain()
        }
    }
    
    func createFeedComment(feedComment: FeedComment) async throws {
        try await feedService.createFeedComment(feedCommentDto: feedComment.toDto())
    }
    
    func getFeedsLikes(feedIDs: [UUID]) async throws -> [FeedLike] {
        try await feedService.getFeedsLikes(feedIDs: feedIDs).map {
            $0.toDomain()
        }
    }
    
    func getAllFeedMedia(mediaType: MediaType, feedID: UUID) async throws -> [Data] {
        try await feedService.getAllFeedMedia(mediaType: mediaType, feedID: feedID)
    }
    
    func likeFeed(feedID: UUID) async throws {
        
        guard let currentProfileID = authenticationService.getCurrentUserID() else {
            return
        }
        
        let feedLike = FeedLike(profileID: currentProfileID, feedID: feedID)
        try await feedService.likeFeed(feedLikeDto: feedLike.toDto())
    }
    
    func unlikeFeed(feedID: UUID) async throws {
        
        guard let currentProfileID = authenticationService.getCurrentUserID() else {
            return
        }
        
        try await feedService.unlikeFeed(feedID: feedID, profileID: currentProfileID)
    }
    
    func observeNewlyAddedFeedChanges() -> AsyncStream<Feed> {
        let feedDtoStream = feedService.observeNewlyAddedFeedChanges()
        
        return AsyncStream { continuation in
            Task {
                for await feedDto in feedDtoStream {
                    continuation.yield(feedDto.toDomain())
                }
                continuation.finish()
            }
        }
    }
    
    func observeNewlyAddedFeedCommentsChanges() -> AsyncStream<FeedComment> {
        let feedCommentStream = feedService.observeNewlyAddedFeedCommentsChanges()
        
        return AsyncStream { continuation in
            Task {
                for await feedCommentDto in feedCommentStream {
                    continuation.yield(feedCommentDto.toDomain())
                }
                continuation.finish()
            }
        }
    }
    
}
