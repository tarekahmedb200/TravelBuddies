//
//  FeedMediaRepositoryImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation


class FeedMediaRepositoryImplementation {
    private let feedMediaService: FeedMediaService
    
    init(feedMediaService: FeedMediaService, authenticationService: AuthenticationService) {
        self.feedMediaService = feedMediaService
    }
}

extension FeedMediaRepositoryImplementation: FeedMediaRepository {
    func deleteFeedMediaDataDto(feedMediaDataID: UUID) async throws {
        try await feedMediaService.deleteFeedMediaDataDto(feedMediaDataID: feedMediaDataID)
    }
    
    func createFeedMediaData(feedMediaData: FeedMediaMetaData) async throws {
        try await feedMediaService.createFeedMediaDataDto(feedMediaData: feedMediaData.toDto())
    }
    
    func getFeedMediaDatas(feedIds: [UUID]) async throws -> [FeedMediaMetaData] {
        try await feedMediaService.getFeedMediaDatasDtos(feedIds: feedIds).map {
            $0.toDomain()
        }
    }
    
    func uploadFeedActualMedia(feedMediaDataID: UUID, mediaData: Data) async throws {
        try await feedMediaService.uploadFeedActualMedia(feedMediaDataID: feedMediaDataID, mediaData: mediaData)
    }
    
    func getFeedActualMedia(feedMediaDataID: UUID) async throws -> Data? {
        try await feedMediaService.getFeedActualMedia(feedMediaDataID: feedMediaDataID)
    }
    
    func deleteFeedActualMedia(feedMediaDataID :UUID) async throws {
        try await feedMediaService.deleteFeedActualMedia(feedMediaDataID: feedMediaDataID)
    }

}
