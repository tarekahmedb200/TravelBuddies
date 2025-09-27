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
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
}

extension UnLikeFeedUseCaseImplementation : UnLikeFeedUseCase {
    func execute(feedID: UUID) async throws  {
        return try await feedRepository.unlikeFeed(feedID: feedID)
    }
}
