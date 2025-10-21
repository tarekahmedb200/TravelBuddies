//
//  FeedMediaRepository.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation

protocol FeedMediaRepository {
    func createFeedMediaData(feedMediaData:FeedMediaMetaData) async throws
    func getFeedMediaDatas(feedIds :[UUID]) async throws -> [FeedMediaMetaData]
    func deleteFeedMediaDataDto(feedMediaDataID :UUID) async throws
    
    func uploadFeedActualMedia(feedMediaDataID: UUID,mediaData: Data) async throws
    func getFeedActualMedia(feedMediaDataID :UUID) async throws -> Data?
    func deleteFeedActualMedia(feedMediaDataID :UUID) async throws
}
