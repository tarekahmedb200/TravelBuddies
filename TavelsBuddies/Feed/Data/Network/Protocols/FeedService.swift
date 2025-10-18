//
//  FeedService.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation

protocol FeedService {
    func createFeed(feed: FeedDto) async throws
    func getAllFeeds() async throws -> [FeedDto]
    func updateFeed(feedDto: FeedDto) async throws
    func deleteFeed(feedID: UUID) async throws
    func observeNewlyAddedFeedChanges() -> AsyncStream<FeedDto>
}
