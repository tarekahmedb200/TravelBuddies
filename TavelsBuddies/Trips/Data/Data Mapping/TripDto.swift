//
//  TripDto.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation


struct TripDto : Codable {
    let id: UUID
    let title: String
    let description: String
    let location: String
    let occurrenceDate: Date
    let createdAt: Date
    let isFree: Bool
    let maxParticipants: Int
    let tags: [String]
    let price: Double
    let adminId: UUID
    let profilesIds: [UUID]
    
    enum CodingKeys: String,CodingKey {
        case id
        case title
        case description
        case location
        case occurrenceDate = "occurrence_date"
        case createdAt = "created_at"
        case isFree = "is_free"
        case maxParticipants = "max_participants"
        case tags
        case price
        case adminId = "admin_id"
        case profilesIds = "profiles_ids"
    }
    
}

extension TripDto {
    func toDomain() -> Trip {
        Trip(
            id: id,
            title: title,
            description: description,
            location: location,
            occurrenceDate: occurrenceDate,
            createdAt: createdAt,
            isFree: isFree,
            maxParticipants: maxParticipants,
            tags: tags,
            price: price,
            adminId: adminId,
            profilesIds: profilesIds
        )
    }
}


extension Trip {
    func toDto() -> TripDto {
        TripDto(
            id: id,
            title: title,
            description: description,
            location: location,
            occurrenceDate: occurrenceDate,
            createdAt: createdAt,
            isFree: isFree,
            maxParticipants: maxParticipants,
            tags: tags,
            price: price,
            adminId: adminId,
            profilesIds: profilesIds
        )
    }
}

