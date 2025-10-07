//
//  UploadRoomImageUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation


protocol UploadChatRoomImageUseCase {
    func execute(chatRoomID:UUID,imageData:Data) async throws
}

class UploadChatRoomImageUseCaseImplementation {
    private let chatRepository: ChatRepository
   
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
}

extension UploadChatRoomImageUseCaseImplementation : UploadChatRoomImageUseCase {
    func execute(chatRoomID:UUID,imageData:Data) async throws  {
        return try await chatRepository.uploadRoomImageData(chatRoomID: chatRoomID, imageData: imageData)
    }
}
