//
//  ObserveMessagesUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation


protocol ObserveMessagesUseCase {
    func execute(chatRoomId: UUID) -> AsyncStream<ChatMessage>
}

class ObserveMessagesUseCaseImplementation {
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
}

extension ObserveMessagesUseCaseImplementation : ObserveMessagesUseCase {
    func execute(chatRoomId: UUID) -> AsyncStream<ChatMessage> {
        return chatRepository.observeMessages(in: chatRoomId)
    }
}
