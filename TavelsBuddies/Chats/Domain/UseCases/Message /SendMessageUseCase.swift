//
//  SendMessageUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation

protocol SendMessageUseCase {
    func execute(roomID:UUID,text:String) async throws
}

class SendMessageUseCaseImplementation {
    private let chatRepository: ChatRepository
    private let authenticationRepository: AuthenticationRepository
    
    init(chatRepository: ChatRepository, authenticationRepository: AuthenticationRepository) {
        self.chatRepository = chatRepository
        self.authenticationRepository = authenticationRepository
    }
}

extension SendMessageUseCaseImplementation : SendMessageUseCase {
    func execute(roomID:UUID,text:String) async throws {
        
        guard let profileID =  authenticationRepository.getCurrentUserID() else {
            return
        }
        
        let chatMessage = ChatMessage(id: UUID(), roomID: roomID, senderID: profileID, text: text, createdAt: Date())
        try await chatRepository.sendMessage(chatMessage)
    }
}
