//
//  FeedLikeRepository.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation


protocol FeedLikeRepository {
    func getFeedsLikes(feedIDs: [UUID]) async throws -> [FeedLike]
    func likeFeed(feedID : UUID) async throws
    func unlikeFeed(feedID : UUID) async throws
}
