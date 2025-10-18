//
//  SupabaseFeedMediaServiceImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation


class SupabaseFeedMediaServiceImplementation {
    
    private let databaseCreate: DatabaseCreateService
    private let databaseGet: DatabaseGetService
    private let databaseDelete: DatabaseDeleteService
    private let newlyInsertedDataObserver: NewlyInsertedDataObserver
    private let supabaseMediaManager: SupabaseMediaManager
    
    private let feedMediaMetaDataTableName = SupabaseTableNames.feedMediaMetaData.rawValue
    private let feedLikeTableName = SupabaseTableNames.feedLike.rawValue
    private let feedCommentTableName = SupabaseTableNames.feedComment.rawValue
    
    private let feedImagesStorageName = SupabaseStorageNames.feedImages.rawValue
    
    init() {
        databaseCreate = DatabaseCreateService()
        databaseGet = DatabaseGetService()
        databaseDelete = DatabaseDeleteService()
        newlyInsertedDataObserver = NewlyInsertedDataObserver()
        supabaseMediaManager = SupabaseMediaManager()
    }
}


extension SupabaseFeedMediaServiceImplementation: FeedMediaService {
    func createFeedMediaDataDto(feedMediaData: FeedMediaMetaDataDto) async throws {
        try await databaseCreate.create(feedMediaData, tableName: feedMediaMetaDataTableName)
    }
    
    func getFeedMediaDatasDtos(feedIds: [UUID]) async throws -> [FeedMediaMetaDataDto] {
        try await databaseGet.getArray(tableName:feedMediaMetaDataTableName,
                                       conditionsWithMutipleValues:
                                        [FeedMediaMetaDataDto.CodingKeys.feedId.rawValue: feedIds]
        )
    }
    
    func uploadFeedActualMedia(feedMediaDataID: UUID, mediaData: Data) async throws {
        try await supabaseMediaManager.uploadImage(storageName: feedImagesStorageName, id: feedMediaDataID, imageData: mediaData)
    }
    
    func getFeedActualMedia(feedMediaDataID: UUID) async throws -> Data? {
        try await supabaseMediaManager.getImage(storageName: feedImagesStorageName, id: feedMediaDataID)
    }
    
    func deleteFeedActualMedia(feedMediaDataID :UUID) async throws {
        try await supabaseMediaManager.deleteImage(storageName: feedImagesStorageName, id: feedMediaDataID)
    }
}
