//
//  FeedLikeService.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation

protocol FeedLikeService {
    func getFeedsLikes(feedIDs: [UUID]) async throws -> [FeedLikeDto]
    func likeFeed(feedLikeDto: FeedLikeDto) async throws
    func unlikeFeed(feedID :UUID,profileID : UUID) async throws
}
