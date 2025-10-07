//
//  GetRoomImageUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation


protocol GetChatRoomImageUseCase {
    func execute(chatRoomID:UUID) async throws -> Data?
}

class GetChatRoomImageUseCaseImplementation {
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
}

extension GetChatRoomImageUseCaseImplementation : GetChatRoomImageUseCase {
    func execute(chatRoomID:UUID) async throws -> Data? {
        return try await chatRepository.getRoomImageData(chatRoomID: chatRoomID)
    }
}
