//
//  FeedService.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation

protocol FeedService {
    func createFeed(feed: FeedDto) async throws
    func getSingleFeed(feedId : UUID) async throws -> FeedDto?
    func getAllFeeds() async throws -> [FeedDto]
    func updateFeed(feedDto: FeedDto) async throws
    func deleteFeed(feedID: UUID) async throws
    func observeFeedChanges() -> AsyncStream<(FeedDto,CrudObservationOperationType)>
}
