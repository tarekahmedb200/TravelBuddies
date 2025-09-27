//
//  GetAllFeedsUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation


protocol GetAllFeedsUseCase {
    func execute() async throws -> [Feed]
}

class GetAllFeedsUseCaseImplementation {
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
}

extension GetAllFeedsUseCaseImplementation : GetAllFeedsUseCase {
    func execute() async throws -> [Feed] {
        return try await feedRepository.getAllFeeds()
    }
}
