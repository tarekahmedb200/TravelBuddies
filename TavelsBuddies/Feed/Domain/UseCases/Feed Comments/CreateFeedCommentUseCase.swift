//
//  CreateFeedCommentUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation


protocol CreateFeedCommentUseCase {
    func execute(feedID: UUID,content: String) async throws
}

class CreateFeedCommentUseCaseImplementation {
    private let feedCommentRepository: FeedCommentRepository
    private let authenticationRepository : AuthenticationRepository
    
    init(feedCommentRepository: FeedCommentRepository, authenticationRepository: AuthenticationRepository) {
        self.feedCommentRepository = feedCommentRepository
        self.authenticationRepository = authenticationRepository
    }
}

extension CreateFeedCommentUseCaseImplementation : CreateFeedCommentUseCase {
    
    func execute(feedID: UUID,content: String) async throws {
        
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw FeedRepositoryError.emptyContent
        }
        
        guard let currentProfileID = authenticationRepository.getCurrentUserID() else {
            throw FeedRepositoryError.unknownError
        }
        
        let feedCommentToCreate = FeedComment(profileID: currentProfileID, comment: content, feedID: feedID)
        try await feedCommentRepository.createFeedComment(feedComment: feedCommentToCreate)
    }
    
}
