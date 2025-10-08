//
//  ChatRoomUIModel.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation
import SwiftUI

struct ChatRoomUIModel: Identifiable, Equatable {
    let id: UUID
    var name: String?
    let memberIDs: [UUID]
    let createdAt: String
    var chatRoomImageData : Data?
    var oneToOneProfileUIModel: ProfileUIModel?
    // UI-specific helper
    var memberCountText: String {
        "\(memberIDs.count) members"
    }
    
    var chatRoomName : String {
        name ?? oneToOneProfileUIModel?.username ?? ""
    }
    
    var chatRoomImage: Image? {
        guard let data = chatRoomImageData,
              let uiImage = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
    

}

extension ChatRoomUIModel {
    static let mocks: [ChatRoomUIModel] = [
        ChatRoomUIModel(
            id: UUID(),
            name: "iOS Developers",
            memberIDs: [
                UUID(), UUID(), UUID(), UUID(), UUID()
            ],
            createdAt: "2025-10-06T15:30:00Z"
        ),
        ChatRoomUIModel(
            id: UUID(),
            name: "Travel Buddies ✈️",
            memberIDs: [
                UUID(), UUID(), UUID()
            ],
            createdAt: "2025-09-28T09:12:00Z"
        ),
        ChatRoomUIModel(
            id: UUID(),
            name: "Gaming Nights 🎮",
            memberIDs: [
                UUID(), UUID(), UUID(), UUID()
            ],
            createdAt: "2025-08-14T19:45:00Z"
        ),
        ChatRoomUIModel(
            id: UUID(),
            name: "Work Project 💼",
            memberIDs: [
                UUID(), UUID()
            ],
            createdAt: "2025-07-02T10:00:00Z"
        )
    ]

}


extension ChatRoom {
    func toUIModel() -> ChatRoomUIModel {
        ChatRoomUIModel(
            id: id,
            name: name,
            memberIDs: memberIDS,
            createdAt: createdAt.toString()
        )
    }
}

