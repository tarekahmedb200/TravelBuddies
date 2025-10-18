//
//  GetFeedMediaDatasUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation

protocol GetFeedMediaDatasUseCase {
    func execute(feedIds: [UUID]) async throws -> [FeedMediaMetaData]
}

class GetFeedMediaDatasUseCaseImplementation {
    private let feedMediaRepository: FeedMediaRepository
    
    init(feedMediaRepository: FeedMediaRepository) {
        self.feedMediaRepository = feedMediaRepository
    }
}

extension GetFeedMediaDatasUseCaseImplementation : GetFeedMediaDatasUseCase {
    func execute(feedIds: [UUID]) async throws -> [FeedMediaMetaData] {
        return try await feedMediaRepository.getFeedMediaDatas(feedIds: feedIds)
    }
}
