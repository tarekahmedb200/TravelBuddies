//
//  UpdateSingleGroupChatRoomUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 08/10/2025.
//

import Foundation

protocol UpdateSingleGroupChatRoomUseCase {
    func execute(chatRoom:ChatRoom) async throws
}

class UpdateSingleGroupChatRoomUseCaseImplementation {
    private var chatRepository : ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
}

extension UpdateSingleGroupChatRoomUseCaseImplementation : UpdateSingleGroupChatRoomUseCase {
    func execute(chatRoom:ChatRoom) async throws {
        try await chatRepository.updateGroupChatRoom(chatRoom: chatRoom)
    }
}
