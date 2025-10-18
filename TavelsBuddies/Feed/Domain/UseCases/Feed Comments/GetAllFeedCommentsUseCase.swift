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
    private let feedCommentRepository: FeedCommentRepository
    
    init(feedCommentRepository: FeedCommentRepository) {
        self.feedCommentRepository = feedCommentRepository
    }
}

extension GetAllFeedCommentsUseCaseImplementation : GetAllFeedCommentsUseCase {
    func execute(feedID: UUID) async throws -> [FeedComment] {
        return try await feedCommentRepository.getFeedComments(feedID: feedID)
    }
}
