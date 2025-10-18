//
//  DeleteFeedUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation

protocol DeleteFeedUseCase {
    func execute(feedID: UUID, feedMetaDatas: [FeedMediaMetaDataUIModel]) async throws
}

class DeleteFeedUseCaseImplementation {
    private let feedRepository: FeedRepository
    private let deleteActualFeedMediaUseCase: DeleteActualFeedMediaUseCase
    
    init(
        feedRepository: FeedRepository,
        deleteActualFeedMediaUseCase: DeleteActualFeedMediaUseCase
    ) {
        self.feedRepository = feedRepository
        self.deleteActualFeedMediaUseCase = deleteActualFeedMediaUseCase
    }
}

extension DeleteFeedUseCaseImplementation: DeleteFeedUseCase {
    
    func execute(feedID: UUID, feedMetaDatas: [FeedMediaMetaDataUIModel]) async throws {
        // Step 1: Delete all associated media files concurrently
        try await deleteMediaFiles(feedMetaDatas: feedMetaDatas)
        
        // Step 2: Delete the feed itself
        try await feedRepository.deleteFeed(feedID: feedID)
    }
    
    private func deleteMediaFiles(feedMetaDatas: [FeedMediaMetaDataUIModel]) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for mediaMetaData in feedMetaDatas {
                group.addTask {
                    try await self.deleteActualFeedMediaUseCase.execute(
                        feedMediaDataID: mediaMetaData.id
                    )
                }
            }
            
            try await group.waitForAll()
        }
    }
}
