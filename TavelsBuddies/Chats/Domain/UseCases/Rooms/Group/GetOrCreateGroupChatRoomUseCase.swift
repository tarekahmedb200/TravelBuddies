//
//  GetOrCreateGroupChatRoomUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 07/10/2025.
//

import Foundation

protocol GetOrCreateGroupChatRoomUseCase {
    func execute(
        chatRoomID: UUID,
        name: String,
        memberIDs: [UUID]
    ) async throws -> ChatRoom
}


class GetOrCreateGroupChatRoomUseCaseImplementation {
    private let getSingleGroupChatRoomUseCase: GetSingleGroupChatRoomUseCase
    private let createRoomUseCase: CreateRoomUseCase

    init(
        getSingleGroupChatRoomUseCase: GetSingleGroupChatRoomUseCase,
        createRoomUseCase: CreateRoomUseCase
    ) {
        self.getSingleGroupChatRoomUseCase = getSingleGroupChatRoomUseCase
        self.createRoomUseCase = createRoomUseCase
    }
}

extension GetOrCreateGroupChatRoomUseCaseImplementation: GetOrCreateGroupChatRoomUseCase {
    func execute(
        chatRoomID: UUID,
        name: String,
        memberIDs: [UUID]
    ) async throws -> ChatRoom {
        // Try to fetch existing group chat room
        if let existingRoom = try await getSingleGroupChatRoomUseCase.execute(chatRoomID: chatRoomID) {
            return existingRoom
        }

        // Create a new group chat room
        let newRoom = ChatRoom(
            id: chatRoomID,
            name: name,
            memberIDS: memberIDs,
            createdAt: Date(),
            isGroup: true
        )

        try await createRoomUseCase.execute(newRoom)
        return newRoom
    }
}
