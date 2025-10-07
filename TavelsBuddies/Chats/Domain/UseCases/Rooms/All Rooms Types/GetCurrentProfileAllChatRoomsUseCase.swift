//
//  GetCurrentProfileAllChatRoomsUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation


protocol GetCurrentProfileAllChatRoomsUseCase {
    func execute() async throws -> [ChatRoom]
}

class GetCurrentProfileAllChatRoomsUseCaseImplementation {
    private let chatRepository: ChatRepository
    private let authenticationRepository: AuthenticationRepository
    
    init(chatRepository: ChatRepository, authenticationRepository: AuthenticationRepository) {
        self.chatRepository = chatRepository
        self.authenticationRepository = authenticationRepository
    }
}

extension GetCurrentProfileAllChatRoomsUseCaseImplementation : GetCurrentProfileAllChatRoomsUseCase {
    func execute() async throws -> [ChatRoom] {
        
        guard let currentProfileID = authenticationRepository.getCurrentUserID() else {
            return []
        }
        
        return try await chatRepository.getRooms(for: currentProfileID)
    }
}
