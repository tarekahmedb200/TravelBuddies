//
//  GetAllFeedCommentsUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation

protocol GetAllFeedCommentsUseCase {
    func execute(feedID: UUID) async throws -> [FeedComment]
}

class GetAllFeedCommentsUseCaseImplementation {
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
}

extension GetAllFeedCommentsUseCaseImplementation : GetAllFeedCommentsUseCase {
    func execute(feedID: UUID) async throws -> [FeedComment] {
        return try await feedRepository.getFeedComments(feedID: feedID)
    }
}
