//
//  ChatRepository.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation

protocol ChatRepository {
    // Messages
    func sendMessage(_ message: ChatMessage) async throws
    func getMessages(in roomId: UUID) async throws -> [ChatMessage]
    func observeMessages(in roomId: UUID) -> AsyncStream<ChatMessage>

    // Rooms
    func createRoom(_ room: ChatRoom) async throws
    func getRooms(for profileID: UUID) async throws -> [ChatRoom]
    
    func getGroupChatRoom(for chatRoomID: UUID) async throws -> ChatRoom?
    func getOneToOneChatRoom(for membersIDS:[UUID]) async throws -> ChatRoom?
    
    func getRoomImageData(chatRoomID: UUID) async throws -> Data?
    func uploadRoomImageData(chatRoomID: UUID,imageData: Data) async throws
}
