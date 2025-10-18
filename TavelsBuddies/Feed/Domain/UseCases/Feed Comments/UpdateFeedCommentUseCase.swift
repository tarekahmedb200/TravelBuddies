//
//  UpdateFeedCommentUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation


protocol UpdateFeedCommentUseCase {
    func execute(feedCommentID: UUID,comment:String) async throws
}

class UpdateFeedCommentUseCaseImplementation {
    private let feedCommentRepository: FeedCommentRepository
    
    init(feedCommentRepository: FeedCommentRepository, authenticationRepository: AuthenticationRepository) {
        self.feedCommentRepository = feedCommentRepository
    }
}

extension UpdateFeedCommentUseCaseImplementation : UpdateFeedCommentUseCase {
    func execute(feedCommentID: UUID,comment:String) async throws {
        
        guard var feedCommentToUpdate = try await feedCommentRepository.getSingleFeedComment(feedCommentID: feedCommentID) else {
            return
        }
        
        feedCommentToUpdate.comment = comment
        try await feedCommentRepository.updateFeedComment(feedComment: feedCommentToUpdate)
    }
}
