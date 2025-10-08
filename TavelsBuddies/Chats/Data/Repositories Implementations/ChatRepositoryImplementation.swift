//
//  ChatRepositoryImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation


class ChatRepositoryImplementation {
    private var chatService: ChatService
    
    init(chatService: ChatService) {
        self.chatService = chatService
    }
}

extension ChatRepositoryImplementation: ChatRepository {
   
    func sendMessage(_ message: ChatMessage) async throws {
        try await chatService.sendMessage(message.toDto())
    }
    
    func getMessages(in roomId: UUID) async throws -> [ChatMessage] {
        try await chatService.getMessages(in: roomId).map {
            $0.toDomain()
        }
    }
    
    func observeMessages(in roomId: UUID) -> AsyncStream<ChatMessage> {
        
        let chatMessageStream = chatService.observeMessages(in: roomId)
        
        return AsyncStream { continuation in
            Task {
                for await chatMessageDto in chatMessageStream {
                    continuation.yield(chatMessageDto.toDomain())
                }
                continuation.finish()
            }
        }
        
    }
    
    func createRoom(_ room: ChatRoom) async throws {
        try await chatService.createRoom(room.toDto())
    }
    
    func getRooms(for profileID: UUID) async throws -> [ChatRoom] {
        try await chatService.getAllRooms(for: profileID).map {
            $0.toDomain()
        }
    }
    
    func getGroupChatRoom(for chatRoomID: UUID) async throws -> ChatRoom? {
        try await chatService.getGroupChatRoom(for: chatRoomID)?.toDomain()
    }
    
    func getOneToOneChatRoom(for membersIDS:[UUID]) async throws -> ChatRoom? {
        try await chatService.getOneToOneChatRoom(for: membersIDS)?.toDomain()
    }
    
    func getRoomImageData(chatRoomID: UUID) async throws -> Data? {
        try await chatService.getRoomImageData(chatRoomID: chatRoomID)
    }
    
    func uploadRoomImageData(chatRoomID: UUID, imageData: Data) async throws {
        try await chatService.uploadRoomImageData(chatRoomID: chatRoomID, imageData: imageData)
    }
    
    func updateGroupChatRoom(chatRoom: ChatRoom) async throws {
        try await chatService.updateGroupChatRoom(chatRoomDto: chatRoom.toDto())
    }
    
}
