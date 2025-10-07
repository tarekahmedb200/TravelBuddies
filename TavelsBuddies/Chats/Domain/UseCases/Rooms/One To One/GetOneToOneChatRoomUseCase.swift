//
//  GetOneToOneChatRoomUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 07/10/2025.
//

import Foundation


protocol GetOneToOneChatRoomUseCase {
    func execute(memberIDS:[UUID]) async throws -> ChatRoom?
}

class GetOneToOneChatRoomUseCaseImplementation {
    private let chatRepository: ChatRepository
    private let authenticationRepository: AuthenticationRepository
    
    init(chatRepository: ChatRepository, authenticationRepository: AuthenticationRepository) {
        self.chatRepository = chatRepository
        self.authenticationRepository = authenticationRepository
    }
    
}

extension GetOneToOneChatRoomUseCaseImplementation : GetOneToOneChatRoomUseCase {
    func execute(memberIDS:[UUID]) async throws -> ChatRoom? {
        return try await chatRepository.getOneToOneChatRoom(for: memberIDS)
    }
}
