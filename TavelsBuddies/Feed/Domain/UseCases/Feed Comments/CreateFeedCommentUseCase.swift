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
    private let feedRepository: FeedRepository
    private let authenticationRepository : AuthenticationRepository
    
    init(feedRepository: FeedRepository,authenticationRepository: AuthenticationRepository) {
        self.feedRepository = feedRepository
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
        
        let feedCommentToCreate = FeedComment(profileID: currentProfileID, content: content, feedID: feedID)
        try await feedRepository.createFeedComment(feedComment: feedCommentToCreate)
    }
    
}
