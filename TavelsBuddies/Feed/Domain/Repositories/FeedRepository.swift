//
//  FeedRepository.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation

protocol FeedRepository {
    func createFeed(feed: Feed) async throws
    func updateFeed(feed: Feed) async throws
    func deleteFeed(feedID: UUID) async throws
    func getAllFeeds() async throws -> [Feed]
    func observeFeedChanges() -> AsyncStream<(Feed,CrudObservationOperationType)>
    func getSingleFeed(feedId: UUID) async throws -> Feed?
}

