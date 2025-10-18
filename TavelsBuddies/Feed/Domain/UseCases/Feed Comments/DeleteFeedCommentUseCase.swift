//
//  DeleteFeedCommentUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation

protocol DeleteFeedCommentUseCase {
    func execute(feedCommentID: UUID) async throws
}

class DeleteFeedCommentUseCaseImplementation {
    private let feedCommentRepository: FeedCommentRepository
    
    init(feedCommentRepository: FeedCommentRepository, authenticationRepository: AuthenticationRepository) {
        self.feedCommentRepository = feedCommentRepository
    }
}

extension DeleteFeedCommentUseCaseImplementation : DeleteFeedCommentUseCase {
    
    func execute(feedCommentID: UUID) async throws {
        try await feedCommentRepository.deleteFeedComment(feedCommentID: feedCommentID)
    }
    
}
  
