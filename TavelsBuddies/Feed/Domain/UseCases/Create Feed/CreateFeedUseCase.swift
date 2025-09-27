//
//  CreateFeedUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation

protocol CreateFeedUseCase {
    func execute(content: String) async throws
}

class CreateFeedUseCaseImplementation {
    private let feedRepository: FeedRepository
    private let authenticationRepository : AuthenticationRepository
    
    init(feedRepository: FeedRepository,authenticationRepository: AuthenticationRepository) {
        self.feedRepository = feedRepository
        self.authenticationRepository = authenticationRepository
    }
}

extension CreateFeedUseCaseImplementation : CreateFeedUseCase {
    
    func execute(content: String) async throws {
        
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw FeedRepositoryError.emptyContent
        }
        
        guard let profileID = authenticationRepository.getCurrentUserID() else {
            throw FeedRepositoryError.unknownError
        }
        
        let feedToCreate = Feed(content: content, profileId: profileID)
        try await feedRepository.createFeed(feed: feedToCreate)
    }
    
}
