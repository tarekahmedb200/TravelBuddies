//
//  FeedLikeDto.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation

struct FeedLikeDto: Codable {
    let id: UUID
    let profileID: UUID
    let feedID: UUID

    enum CodingKeys: String, CodingKey {
        case id
        case profileID = "profile_id"
        case feedID = "feed_id"
    }
}


extension FeedLikeDto {
    func toDomain() -> FeedLike {
        FeedLike(id: id, profileID: profileID, feedID: feedID)
    }
}

extension FeedLike {
    func toDto() -> FeedLikeDto {
        FeedLikeDto(id: id, profileID: profileID, feedID: feedID)
    }
}



