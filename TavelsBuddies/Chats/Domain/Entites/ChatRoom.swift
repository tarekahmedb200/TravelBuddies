//
//  ChatRoom.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation


struct ChatRoom {
    let id: UUID
    var name: String?
    let memberIDS: [UUID]
    let createdAt: Date
    let isGroup: Bool
}

