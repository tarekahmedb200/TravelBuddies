//
//  UpdateFeedUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation

protocol UpdateFeedUseCase {
    func execute(
        feedId: UUID,
        content: String,
        oldFeedMediaMetaDataUIModels: [FeedMediaMetaDataUIModel],
        newFeedMediaMetaDataUIModels: [FeedMediaMetaDataUIModel]
    ) async throws
}

class UpdateFeedUseCaseImplementation {
    private let feedRepository: FeedRepository
    private let createFeedMediaMetaDataUseCase: CreateFeedMediaMetaDataUseCase
    private let uploadActualFeedMediaUseCase: UploadActualFeedMediaUseCase
    private let deleteActualFeedMediaUseCase: DeleteActualFeedMediaUseCase
    private let deleteFeedMediaMetaDataUseCase: DeleteFeedMediaMetaDataUseCase
    private let getSingleFeedUseCase: GetSingleFeedUseCase
    
    init(
        feedRepository: FeedRepository,
        createFeedMediaMetaDataUseCase: CreateFeedMediaMetaDataUseCase,
        uploadActualFeedMediaUseCase: UploadActualFeedMediaUseCase,
        deleteActualFeedMediaUseCase: DeleteActualFeedMediaUseCase,
        deleteFeedMediaMetaDataUseCase: DeleteFeedMediaMetaDataUseCase,
        getSingleFeedUseCase: GetSingleFeedUseCase
    ) {
        self.feedRepository = feedRepository
        self.createFeedMediaMetaDataUseCase = createFeedMediaMetaDataUseCase
        self.uploadActualFeedMediaUseCase = uploadActualFeedMediaUseCase
        self.deleteActualFeedMediaUseCase = deleteActualFeedMediaUseCase
        self.deleteFeedMediaMetaDataUseCase = deleteFeedMediaMetaDataUseCase
        self.getSingleFeedUseCase = getSingleFeedUseCase
    }
}

extension UpdateFeedUseCaseImplementation: UpdateFeedUseCase {
    func execute(
        feedId: UUID,
        content: String,
        oldFeedMediaMetaDataUIModels: [FeedMediaMetaDataUIModel],
        newFeedMediaMetaDataUIModels: [FeedMediaMetaDataUIModel]
    ) async throws {
        
        // 1) Fetch existing feed and update content only
        guard let existingFeed = try await getSingleFeedUseCase.execute(feedId: feedId) else {
            // If you prefer a dedicated error, add a `.notFound` case to FeedRepositoryError.
            throw FeedRepositoryError.unknownError
        }
        let feedToUpdate = Feed(
            id: existingFeed.id,
            content: content,
            createdAt: existingFeed.createdAt,
            profileId: existingFeed.profileId
        )
        try await feedRepository.updateFeed(feed: feedToUpdate)
        
        // 2) Diff media
        let oldIDs = Set(oldFeedMediaMetaDataUIModels.map(\.id))
        let newIDs = Set(newFeedMediaMetaDataUIModels.map(\.id))
        
        let removedIDs = oldIDs.subtracting(newIDs)
        let addedIDs = newIDs.subtracting(oldIDs)
        
        let removedMedia = oldFeedMediaMetaDataUIModels.filter { removedIDs.contains($0.id) }
        let addedMedia = newFeedMediaMetaDataUIModels.filter { addedIDs.contains($0.id) }
        
        // 3) Single group: per-media tasks with sequential steps inside each task
        try await withThrowingTaskGroup(of: Void.self) { group in
            // Removed media: delete metadata, then delete actual file
            for media in removedMedia {
                group.addTask {
                    try await self.deleteFeedMediaMetaDataUseCase.execute(feedMediaDataID: media.id)
                    try await self.deleteActualFeedMediaUseCase.execute(feedMediaDataID: media.id)
                }
            }
            
            // Added media: create metadata, then upload actual media
            for media in addedMedia {
                group.addTask {
                    // Create metadata (ensure feedId present)
                    var domainMeta: FeedMediaMetaData
                    if var tmp = await media.toDomain() {
                        tmp.feedId = feedId
                        domainMeta = tmp
                    } else {
                        // If UI model lacked feedId, set it and convert again
                        // But since UI model may be a value type, we build the domain directly
                        domainMeta = FeedMediaMetaData(id: media.id, feedId: feedId, mediaType: media.mediaType)
                    }
                    
                    try await self.createFeedMediaMetaDataUseCase.execute(feedMediaMetaData: domainMeta)
                    
                    // Upload actual media if data exists
                    if let data = media.feedImageData {
                        try await self.uploadActualFeedMediaUseCase.execute(feedMediaDataID: media.id, feedMediaData: data)
                    }
                }
            }
            
            try await group.waitForAll()
        }
    }
}
