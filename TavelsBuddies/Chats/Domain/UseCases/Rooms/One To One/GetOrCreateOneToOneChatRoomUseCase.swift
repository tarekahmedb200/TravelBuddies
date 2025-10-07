//
//  GetOrCreateOneToOneChatRoomUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 07/10/2025.
//

import Foundation

protocol GetOrCreateOneToOneChatRoomUseCase {
    func execute(memberIDs: [UUID]) async throws -> ChatRoom
}

class GetOrCreateOneToOneChatRoomUseCaseImplementation {
    private let getOneToOneChatRoomUseCase: GetOneToOneChatRoomUseCase
    private let createRoomUseCase: CreateRoomUseCase

    init(
        getOneToOneChatRoomUseCase: GetOneToOneChatRoomUseCase,
        createRoomUseCase: CreateRoomUseCase
    ) {
        self.getOneToOneChatRoomUseCase = getOneToOneChatRoomUseCase
        self.createRoomUseCase = createRoomUseCase
    }
}

extension GetOrCreateOneToOneChatRoomUseCaseImplementation: GetOrCreateOneToOneChatRoomUseCase {
    func execute(memberIDs: [UUID]) async throws -> ChatRoom {
        // Try to get existing one-to-one chat room
        if let existingRoom = try await getOneToOneChatRoomUseCase.execute(memberIDS: memberIDs) {
            return existingRoom
        }

        // Create a new one-to-one room
        let newRoom = ChatRoom(
            id: UUID(),
            memberIDS: memberIDs,
            createdAt: Date(),
            isGroup: false
        )

        try await createRoomUseCase.execute(newRoom)
        return newRoom
    }
}

