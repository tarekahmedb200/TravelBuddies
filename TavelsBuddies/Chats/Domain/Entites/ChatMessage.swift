//
//  ChatMessage.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let roomID: UUID
    let senderID: UUID
    let text: String
    let createdAt: Date
}
