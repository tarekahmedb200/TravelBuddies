//
//  DeleteFeedMediaMetaDataUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 20/10/2025.
//

import Foundation

protocol DeleteFeedMediaMetaDataUseCase {
    func execute(feedMediaDataID: UUID) async throws
}

class DeleteFeedMediaMetaDataUseCaseImplementation {
    private let feedMediaRepository: FeedMediaRepository
    
    init(feedMediaRepository: FeedMediaRepository) {
        self.feedMediaRepository = feedMediaRepository
    }
}

extension DeleteFeedMediaMetaDataUseCaseImplementation : DeleteFeedMediaMetaDataUseCase {
    func execute(feedMediaDataID: UUID) async throws  {
        try await feedMediaRepository.deleteFeedMediaDataDto(feedMediaDataID: feedMediaDataID)
    }
}
