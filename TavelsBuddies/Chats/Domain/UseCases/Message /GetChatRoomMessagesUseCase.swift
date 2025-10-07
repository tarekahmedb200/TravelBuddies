//
//  GetMessagesUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation

protocol GetChatRoomMessagesUseCase {
    func execute(in roomId: UUID) async throws -> [ChatMessage]
}

class GetChatRoomMessagesUseCaseImplementation {
    private let chatRepository: ChatRepository

    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
}

extension GetChatRoomMessagesUseCaseImplementation: GetChatRoomMessagesUseCase {
    func execute(in roomId: UUID) async throws -> [ChatMessage] {
        try await chatRepository.getMessages(in: roomId)
    }
}
