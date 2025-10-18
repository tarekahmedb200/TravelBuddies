//
//  FeedMediaService.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation

protocol FeedMediaService {
    func createFeedMediaDataDto(feedMediaData:FeedMediaMetaDataDto) async throws
    func getFeedMediaDatasDtos(feedIds :[UUID]) async throws -> [FeedMediaMetaDataDto]
    
    func uploadFeedActualMedia(feedMediaDataID: UUID,mediaData: Data) async throws
    func getFeedActualMedia(feedMediaDataID :UUID) async throws -> Data?
    func deleteFeedActualMedia(feedMediaDataID :UUID) async throws
}
