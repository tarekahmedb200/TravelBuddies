//
//  LikeFeedUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation

protocol LikeFeedUseCase {
    func execute(feedID: UUID) async throws
}

class LikeFeedUseCaseImplementation {
    private let feedLikeRepository: FeedLikeRepository
    
    init(feedLikeRepository: FeedLikeRepository) {
        self.feedLikeRepository = feedLikeRepository
    }
}

extension LikeFeedUseCaseImplementation : LikeFeedUseCase {
    func execute(feedID: UUID) async throws  {
        return try await feedLikeRepository.likeFeed(feedID: feedID)
    }
}
