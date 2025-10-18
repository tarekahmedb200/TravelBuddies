//
//  GetFeedMediaUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation

protocol GetActualFeedMediaUseCase {
    func execute(feedMediaDataID: UUID) async throws -> Data?
}

class GetActualFeedMediaUseCaseImplementation {
    private let feedMediaRepository: FeedMediaRepository
    
    init(feedMediaRepository: FeedMediaRepository) {
        self.feedMediaRepository = feedMediaRepository
    }
}

extension GetActualFeedMediaUseCaseImplementation : GetActualFeedMediaUseCase {
    func execute(feedMediaDataID: UUID) async throws -> Data? {
        return try await feedMediaRepository.getFeedActualMedia(feedMediaDataID: feedMediaDataID)
    }
}
