//
//  ChatMessageDto.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation

// MARK: - DTO

struct ChatMessageDto: Identifiable, Codable {
    let id: UUID
    let roomID: UUID
    let senderID: UUID
    let message: String
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case roomID = "room_id"
        case senderID = "sender_id"
        case message
        case createdAt = "created_at"
    }
}

// MARK: - Decode from Dictionary

extension ChatMessageDto {
    static func from(dictionary: [String: Any]) throws -> ChatMessageDto {
        // Debug print
        dictionary.forEach { key, value in
            print(key, value)
        }
        
        let id = try dictionary.decodeUUID(for: CodingKeys.id.rawValue)
        let roomID = try dictionary.decodeUUID(for: CodingKeys.roomID.rawValue)
        let senderID = try dictionary.decodeUUID(for: CodingKeys.senderID.rawValue)
        let text = try dictionary.decodeString(for: CodingKeys.message.rawValue)
        let createdAt = try dictionary.decodeDate(for: CodingKeys.createdAt.rawValue)
        
        return ChatMessageDto(
            id: id,
            roomID: roomID,
            senderID: senderID,
            message: text,
            createdAt: createdAt
        )
    }
}

// MARK: - Domain Conversion

extension ChatMessageDto {
    func toDomain() -> ChatMessage {
        return ChatMessage(
            id: id,
            roomID: roomID,
            senderID: senderID,
            text: message,
            createdAt: createdAt
        )
    }
}

extension ChatMessage {
    func toDto() -> ChatMessageDto {
        return ChatMessageDto(
            id: id,
            roomID: roomID,
            senderID: senderID,
            message: text,
            createdAt: createdAt
        )
    }
}

