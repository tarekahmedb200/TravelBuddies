//
//  DeleteActualFeedMediaUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation


protocol DeleteActualFeedMediaUseCase {
    func execute(feedMediaDataID: UUID) async throws
}

class DeleteActualFeedMediaUseCaseImplementation {
    private let feedMediaRepository: FeedMediaRepository
    
    init(feedMediaRepository: FeedMediaRepository) {
        self.feedMediaRepository = feedMediaRepository
    }
}

extension DeleteActualFeedMediaUseCaseImplementation : DeleteActualFeedMediaUseCase {
    
    func execute(feedMediaDataID: UUID) async throws  {
        try await feedMediaRepository.deleteFeedActualMedia(feedMediaDataID: feedMediaDataID)
    }
}
