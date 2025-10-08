//
//  ChatService.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation


protocol ChatService {
    // Messages
    func sendMessage(_ message: ChatMessageDto) async throws
    func getMessages(in roomId: UUID) async throws -> [ChatMessageDto]
    func observeMessages(in roomId: UUID) -> AsyncStream<ChatMessageDto>

    // Rooms
    func createRoom(_ room: ChatRoomDto) async throws
    func getAllRooms(for userId: UUID) async throws -> [ChatRoomDto]
    
    func getGroupChatRoom(for chatRoomID: UUID) async throws -> ChatRoomDto?
    func updateGroupChatRoom(chatRoomDto: ChatRoomDto) async throws
    func getOneToOneChatRoom(for membersIDS:[UUID]) async throws -> ChatRoomDto?
    
    func getRoomImageData(chatRoomID: UUID) async throws -> Data?
    func uploadRoomImageData(chatRoomID: UUID,imageData: Data) async throws
}
