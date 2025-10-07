//
//  CreateRoomUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation
import Foundation

protocol CreateRoomUseCase {
    func execute(_ room: ChatRoom) async throws
}

class CreateRoomUseCaseImplementation {
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
}

extension CreateRoomUseCaseImplementation : CreateRoomUseCase {
    func execute(_ room: ChatRoom) async throws {
        try await chatRepository.createRoom(room)
    }
}
