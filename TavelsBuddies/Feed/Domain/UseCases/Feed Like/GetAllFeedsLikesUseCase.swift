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
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
}

extension GetAllFeedsLikesUseCaseImplementation : GetAllFeedsLikesUseCase {
    func execute(feedIDs: [UUID]) async throws -> [FeedLike] {
        return try await feedRepository.getFeedsLikes(feedIDs: feedIDs)
    }
}
