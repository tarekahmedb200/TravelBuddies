//
//  GetFeedMediaUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation

protocol GetFeedMediaUseCase {
    func execute(mediaType : MediaType,feedID: UUID) async throws -> [Data]
}

class GetFeedMediaUseCaseImplementation {
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
}

extension GetFeedMediaUseCaseImplementation : GetFeedMediaUseCase {
    func execute(mediaType : MediaType,feedID: UUID) async throws -> [Data] {
        return try await feedRepository.getAllFeedMedia(mediaType: mediaType, feedID: feedID)
    }
}
