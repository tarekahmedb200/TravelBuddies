//
//  FeedMediaMetaDataDto.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation

struct FeedMediaMetaDataDto: Codable {
    var id : UUID
    var feedId : UUID
    var mediaType : MediaType
    
    enum CodingKeys: String,CodingKey {
        case id
        case feedId = "feed_id"
        case mediaType = "media_type"
    }
}

extension FeedMediaMetaDataDto {
    func toDomain() -> FeedMediaMetaData {
        return FeedMediaMetaData(
            id: id,
            feedId: feedId,
            mediaType: mediaType
        )
    }
}

extension FeedMediaMetaData {
    func toDto() -> FeedMediaMetaDataDto {
        return FeedMediaMetaDataDto(
            id: id,
            feedId: feedId,
            mediaType: mediaType
        )
    }
}
