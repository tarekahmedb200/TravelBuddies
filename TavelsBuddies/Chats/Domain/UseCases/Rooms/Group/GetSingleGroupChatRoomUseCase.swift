//
//  GetSingleGrouoChatRoomUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 07/10/2025.
//

import Foundation


protocol GetSingleGroupChatRoomUseCase {
    func execute(chatRoomID:UUID) async throws -> ChatRoom?
}

class GetSingleGroupChatRoomUseCaseImplementation {
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
}

extension GetSingleGroupChatRoomUseCaseImplementation : GetSingleGroupChatRoomUseCase {
    func execute(chatRoomID:UUID) async throws -> ChatRoom? {
        return try await chatRepository.getGroupChatRoom(for: chatRoomID)
    }
}
