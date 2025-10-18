//
//  FeedLikeRepositoryImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation



class FeedLikeRepositoryImplementation {
    private let feedLikeService: FeedLikeService
    private let authenticationService: AuthenticationService
    
    init (feedLikeService: FeedLikeService, authenticationService: AuthenticationService) {
        self.feedLikeService = feedLikeService
        self.authenticationService = authenticationService
    }
}

extension FeedLikeRepositoryImplementation: FeedLikeRepository {
    
    func getFeedsLikes(feedIDs: [UUID]) async throws -> [FeedLike] {
        try await feedLikeService.getFeedsLikes(feedIDs: feedIDs).map {
            $0.toDomain()
        }
    }
    

    func likeFeed(feedID: UUID) async throws {
        
        guard let currentProfileID = authenticationService.getCurrentUserID() else {
            return
        }
        
        let feedLike = FeedLike(profileID: currentProfileID, feedID: feedID)
        try await feedLikeService.likeFeed(feedLikeDto: feedLike.toDto())
    }
    
    func unlikeFeed(feedID: UUID) async throws {
        
        guard let currentProfileID = authenticationService.getCurrentUserID() else {
            return
        }
        
        try await feedLikeService.unlikeFeed(feedID: feedID, profileID: currentProfileID)
    }
    
}
