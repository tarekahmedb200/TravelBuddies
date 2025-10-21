//
//  GetSingleFeedUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 20/10/2025.
//

import Foundation

protocol GetSingleFeedUseCase {
    func execute(feedId: UUID) async throws -> Feed?
}

final class GetSingleFeedUseCaseImplementation: GetSingleFeedUseCase {
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
    
    func execute(feedId: UUID) async throws -> Feed? {
        try await feedRepository.getSingleFeed(feedId: feedId)
    }
}

