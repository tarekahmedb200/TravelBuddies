//
//  FeedCommentDto.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation


struct FeedCommentDto: Codable {
    let id: UUID
    let content: String
    let createdAt: Date
    let profileID: UUID
    let feedID: UUID
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case createdAt = "created_at"
        case profileID = "profile_id"
        case feedID = "feed_id"
    }
}

extension FeedCommentDto {
    static func from(dictionary: [String: Any]) throws -> FeedCommentDto {
        
        dictionary.forEach { key, value in
            print(key, value)
        }
        
        let id = try dictionary.decodeUUID(for: CodingKeys.id.rawValue)
        let content = try dictionary.decodeString(for: CodingKeys.content.rawValue)
        let createdAt = try dictionary.decodeDate(for: CodingKeys.createdAt.rawValue)
        let profileID = try dictionary.decodeUUID(for: CodingKeys.profileID.rawValue)
        let feedID = try dictionary.decodeUUID(for: CodingKeys.feedID.rawValue)
        
        return FeedCommentDto(
            id: id,
            content: content,
            createdAt: createdAt,
            profileID: profileID,
            feedID: feedID
        )
    }
}


extension FeedCommentDto {
    func toDomain() -> FeedComment {
        return FeedComment(id: id, profileID: profileID, content: content, createdAt: createdAt, feedID: feedID)
    }
}


extension FeedComment {
    func toDto () -> FeedCommentDto {
        return FeedCommentDto(id: id, content: content, createdAt: createdAt, profileID: profileID, feedID: feedID)
    }
}

