//
//  GetOrCreateGroupChatRoomUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 07/10/2025.
//

import Foundation

import Foundation

// MARK: - Protocol
protocol PrepareGroupChatRoomUseCase {
    func execute(
        chatRoomID: UUID,
        name: String,
        memberIDs: [UUID]
    ) async throws -> ChatRoom
}

// MARK: - Implementation
class PrepareGroupChatRoomUseCaseImplementation {
    private let getSingleGroupChatRoomUseCase: GetSingleGroupChatRoomUseCase
    private let createRoomUseCase: CreateRoomUseCase
    private let updateGroupChatRoomUseCase: UpdateSingleGroupChatRoomUseCase

    init(
        getSingleGroupChatRoomUseCase: GetSingleGroupChatRoomUseCase,
        createRoomUseCase: CreateRoomUseCase,
        updateGroupChatRoomUseCase: UpdateSingleGroupChatRoomUseCase
    ) {
        self.getSingleGroupChatRoomUseCase = getSingleGroupChatRoomUseCase
        self.createRoomUseCase = createRoomUseCase
        self.updateGroupChatRoomUseCase = updateGroupChatRoomUseCase
    }
}

// MARK: - Logic
extension PrepareGroupChatRoomUseCaseImplementation: PrepareGroupChatRoomUseCase {
    func execute(
        chatRoomID: UUID,
        name: String,
        memberIDs: [UUID]
    ) async throws -> ChatRoom {

        // Try to get existing group chat room
        if let existingRoom = try await getSingleGroupChatRoomUseCase.execute(chatRoomID: chatRoomID) {
            // If members differ, update the room
            if Set(existingRoom.memberIDS) != Set(memberIDs) {
                let updatedRoom = ChatRoom(
                    id: existingRoom.id,
                    name: existingRoom.name,
                    memberIDS: memberIDs,
                    createdAt: existingRoom.createdAt,
                    isGroup: true
                )

                try await updateGroupChatRoomUseCase.execute(chatRoom: updatedRoom)
                return updatedRoom
            }

            // No update needed, return existing
            return existingRoom
        }

        // If not found, create a new group chat room
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
