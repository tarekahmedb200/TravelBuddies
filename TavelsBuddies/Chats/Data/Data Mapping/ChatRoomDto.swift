//
//  ChatRoomDto.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation


struct ChatRoomDto : Codable , Identifiable {
    let id: UUID
    var name: String? 
    let membersIDS: [UUID]
    let createdAt: Date
    let isGroup: Bool
    
    enum CodingKeys: String,CodingKey {
        case id
        case name
        case membersIDS = "members_ids"
        case createdAt = "created_at"
        case isGroup = "is_group"
    }
}


extension ChatRoomDto {
    func toDomain() -> ChatRoom {
        return ChatRoom(
            id: id,
            name: name,
            memberIDS: membersIDS,
            createdAt: createdAt,
            isGroup: isGroup
        )
    }
}

extension ChatRoom {
    func toDto() -> ChatRoomDto {
        return ChatRoomDto(
            id: id,
            name: name,
            membersIDS: memberIDS,
            createdAt: createdAt,
            isGroup: isGroup
        )
    }
}

