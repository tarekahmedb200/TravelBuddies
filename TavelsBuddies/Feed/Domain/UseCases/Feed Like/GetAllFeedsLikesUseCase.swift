//
//  GetAllFeedLikesUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation


protocol GetAllFeedsLikesUseCase {
    func execute(feedIDs: [UUID]) async throws -> [FeedLike]
}

class GetAllFeedsLikesUseCaseImplementation {
    private let feedLikeRepository: FeedLikeRepository
    
    init(feedLikeRepository: FeedLikeRepository) {
        self.feedLikeRepository = feedLikeRepository
    }
}

extension GetAllFeedsLikesUseCaseImplementation : GetAllFeedsLikesUseCase {
    func execute(feedIDs: [UUID]) async throws -> [FeedLike] {
        return try await feedLikeRepository.getFeedsLikes(feedIDs: feedIDs)
    }
}
