//
//  FeedDto.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation
import Supabase


struct FeedDto: Codable {
    let id: UUID
    let content: String
    let createdAt: Date
    let profileId: UUID
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case content = "content"
        case createdAt = "created_at"
        case profileId = "profile_id"
    }
}

extension FeedDto {
    static func from(dictionary: [String: Any]) throws -> FeedDto {
        let id = try dictionary.decodeUUID(for: CodingKeys.id.rawValue)
        let content = try dictionary.decodeString(for: CodingKeys.content.rawValue)
        let createdAt = try dictionary.decodeDate(for: CodingKeys.createdAt.rawValue)
        let profileId = try dictionary.decodeUUID(for: CodingKeys.profileId.rawValue)
        
        return FeedDto(
            id: id,
            content: content,
            createdAt: createdAt,
            profileId: profileId
        )
    }
}

enum MappingError: Error {
    case invalidOrMissing(key: String)
}

extension FeedDto {
    func toDomain() -> Feed {
        Feed(id: id, content: content, createdAt: createdAt, profileId: profileId)
    }
}

extension Feed {
    func toDto() -> FeedDto {
        FeedDto(id: id, content: content, createdAt: createdAt, profileId: profileId)
    }
}

