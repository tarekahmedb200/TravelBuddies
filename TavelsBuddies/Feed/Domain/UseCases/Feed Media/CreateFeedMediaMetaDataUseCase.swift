//
//  CreateFeedMediaDataUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation

protocol CreateFeedMediaMetaDataUseCase {
    func execute(feedMediaMetaData:FeedMediaMetaData) async throws
}

class CreateFeedMediaMetaDataUseCaseImplementation {
    private let feedMediaRepository: FeedMediaRepository
    
    init(feedMediaRepository: FeedMediaRepository) {
        self.feedMediaRepository = feedMediaRepository
    }
}

extension CreateFeedMediaMetaDataUseCaseImplementation : CreateFeedMediaMetaDataUseCase {
    func execute(feedMediaMetaData:FeedMediaMetaData) async throws {
        return try await feedMediaRepository.createFeedMediaData(feedMediaData: feedMediaMetaData)
    }
}


