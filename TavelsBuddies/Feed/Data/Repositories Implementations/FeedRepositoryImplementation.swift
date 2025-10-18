//
//  FeedRepositoryImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation


class FeedRepositoryImplementation {
    private let feedService: FeedService
    
    init(feedService: FeedService, authenticationService: AuthenticationService) {
        self.feedService = feedService
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
    
    
    func updateFeed(feed: Feed) async throws {
        try await feedService.updateFeed(feedDto: feed.toDto())
    }
    
    func deleteFeed(feedID: UUID) async throws {
        try await feedService.deleteFeed(feedID: feedID)
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
    
}
