//
//  UnLikeFeedUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation


import Foundation

protocol UnLikeFeedUseCase {
    func execute(feedID: UUID) async throws
}

class UnLikeFeedUseCaseImplementation {
    private let feedLikeRepository: FeedLikeRepository
    
    init(feedLikeRepository: FeedLikeRepository) {
        self.feedLikeRepository = feedLikeRepository
    }
}

extension UnLikeFeedUseCaseImplementation : UnLikeFeedUseCase {
    func execute(feedID: UUID) async throws  {
        return try await feedLikeRepository.unlikeFeed(feedID: feedID)
    }
}
