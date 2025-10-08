//
//  ChatMessageUIModel.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation

struct ChatMessageUIModel: Identifiable, Equatable {
    let id: UUID
    let roomID: UUID
    let text: String
    let createdAt: Date
    var profileUIModel: ProfileUIModel?
    var isCurrentUser: Bool = false
}

extension ChatMessageUIModel {
    
    // Shared mock IDs (consistent across all messages)
    static let mockedRoomID = UUID()
    
    static var mocks: [ChatMessageUIModel] {
        [
            .init(
                id: UUID(),
                roomID: mockedRoomID,
                text: "Hey everyone 👋",
                createdAt: ISO8601DateFormatter().date(from: "2025-10-06T15:31:00Z") ?? Date(),
                profileUIModel: nil,
                isCurrentUser: false
            ),
            .init(
                id: UUID(),
                roomID: mockedRoomID,
                text: "How’s the new Swift update?",
                createdAt: ISO8601DateFormatter().date(from: "2025-10-06T15:32:00Z") ?? Date(),
                profileUIModel: nil,
                isCurrentUser: true
            ),
            .init(
                id: UUID(),
                roomID: mockedRoomID,
                text: "It’s amazing! Async sequences are 🔥",
                createdAt: ISO8601DateFormatter().date(from: "2025-10-06T15:33:00Z") ?? Date(),
                profileUIModel: nil,
                isCurrentUser: false
            )
        ]
    }
}

extension ChatMessage {
    func toUIModel() -> ChatMessageUIModel {
        ChatMessageUIModel(
            id: id,
            roomID: roomID,
            text: text,
            createdAt: createdAt
        )
    }
}


