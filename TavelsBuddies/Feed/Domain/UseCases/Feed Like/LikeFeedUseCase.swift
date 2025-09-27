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
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
}

extension LikeFeedUseCaseImplementation : LikeFeedUseCase {
    func execute(feedID: UUID) async throws  {
        return try await feedRepository.likeFeed(feedID: feedID)
    }
}
