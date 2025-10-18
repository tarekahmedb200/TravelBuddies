//
//  CreateFeedUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation

protocol CreateFeedUseCase {
    func execute(content: String,feedMediaMetaDataUIModels:[FeedMediaMetaDataUIModel]) async throws
}

class CreateFeedUseCaseImplementation {
    private let createFeedMediaMetaDataUseCase: CreateFeedMediaMetaDataUseCase
    private let uploadActualFeedMediaUseCase: UploadActualFeedMediaUseCase
    private let feedRepository: FeedRepository
    private let authenticationRepository: AuthenticationRepository
    
    init(createFeedMediaMetaDataUseCase: CreateFeedMediaMetaDataUseCase, uploadActualFeedMediaUseCase: UploadActualFeedMediaUseCase, feedRepository: FeedRepository, authenticationRepository: AuthenticationRepository) {
        self.createFeedMediaMetaDataUseCase = createFeedMediaMetaDataUseCase
        self.uploadActualFeedMediaUseCase = uploadActualFeedMediaUseCase
        self.feedRepository = feedRepository
        self.authenticationRepository = authenticationRepository
    }
}

extension CreateFeedUseCaseImplementation: CreateFeedUseCase {
    func execute(
        content: String,
        feedMediaMetaDataUIModels: [FeedMediaMetaDataUIModel]
    ) async throws {
       
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw FeedRepositoryError.emptyContent
        }
        
        guard let profileID = authenticationRepository.getCurrentUserID() else {
            throw FeedRepositoryError.unknownError
        }
        
        // Step 3: Create the feed
        let feedToCreate = Feed(content: content, profileId: profileID)
        try await feedRepository.createFeed(feed: feedToCreate)
     
        // Step 4: Handle media if provided
        if !feedMediaMetaDataUIModels.isEmpty {
            
            let modifiedFeedMediaMetaDataUIModels = feedMediaMetaDataUIModels.map {
                
                var modifiedFeedMediaMetaDataUIModel = $0
                modifiedFeedMediaMetaDataUIModel.feedId = feedToCreate.id
                return modifiedFeedMediaMetaDataUIModel
            }
            
            try await processMediaFiles(
                feedID: feedToCreate.id,
                mediaModels: modifiedFeedMediaMetaDataUIModels
            )
        }
        
    }
    
    private func processMediaFiles(
        feedID: UUID,
        mediaModels: [FeedMediaMetaDataUIModel]
    ) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for mediaModel in mediaModels {
                group.addTask {
                    // Step 4a: Create metadata entry
                    guard var domainMediaMetaData = await mediaModel.toDomain() else {
                        return
                    }
                    
                    domainMediaMetaData.feedId = feedID
                    
                    try await self.createFeedMediaMetaDataUseCase.execute(
                        feedMediaMetaData: domainMediaMetaData
                    )
                    
                    // Step 4b: Upload actual media if data exists
                    if let mediaData = mediaModel.feedImageData {
                        try await self.uploadActualFeedMediaUseCase.execute(
                            feedMediaDataID: mediaModel.id,
                            feedMediaData: mediaData
                        )
                    }
                }
            }
            
            // Wait for all tasks to complete
            try await group.waitForAll()
        }
    }
}
