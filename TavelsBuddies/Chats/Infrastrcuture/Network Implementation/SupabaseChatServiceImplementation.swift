//
//  SupabaseChatServiceImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation


class SupabaseChatServiceImplementation {
    private let databaseCreate: DatabaseCreateService
    private let databaseGet: DatabaseGetService
    private let databaseUpdate: DatabaseUpdateService
    private let databaseDelete: DatabaseDeleteService
    private let newlyInsertedDataObserver: SupabaseDataObserver
    private let supabaseMediaManager: SupabaseMediaManager
    
    private let chatMessageTableName = SupabaseTableNames.chatMessage.rawValue
    private let chatRoomTableName = SupabaseTableNames.chatRoom.rawValue
    private let chatRoomImageStorageName = SupabaseStorageNames.chatRoomImages.rawValue
    
    init() {
        databaseCreate = DatabaseCreateService()
        databaseGet = DatabaseGetService()
        databaseUpdate = DatabaseUpdateService()
        databaseDelete = DatabaseDeleteService()
        supabaseMediaManager = SupabaseMediaManager()
        newlyInsertedDataObserver = SupabaseDataObserver()
    }
}

extension SupabaseChatServiceImplementation: ChatService {
    
    func sendMessage(_ message: ChatMessageDto) async throws {
        try await databaseCreate.create(message, tableName: chatMessageTableName)
    }
    
    func getMessages(in roomId: UUID) async throws -> [ChatMessageDto] {
        try await databaseGet.getArray(tableName: chatMessageTableName,conditionsWithSingleValue: [
            ChatMessageDto.CodingKeys.roomID.rawValue: roomId
        ])
    }
    
    func observeMessages(in roomId: UUID) -> AsyncStream<ChatMessageDto> {
        let stream = newlyInsertedDataObserver.start(tableName: chatMessageTableName,columnName: ChatMessageDto.CodingKeys.roomID.rawValue,value: roomId)
        return AsyncStream { continuation in
            Task {
                for await (chatMessageJson,crudType) in stream {
                    do {
                        let chatMessageDto = try ChatMessageDto.from(dictionary: chatMessageJson)
                        continuation.yield(chatMessageDto)
                    } catch {
                        print("Decode error:", error)
                    }
                }
                continuation.finish()
            }
        }
    }
    
    
    func createRoom(_ room: ChatRoomDto) async throws {
        try await databaseCreate.create(room, tableName: chatRoomTableName)
    }
    
    func getAllRooms(for userId: UUID) async throws -> [ChatRoomDto] {
        try await databaseGet.getArray(tableName: chatRoomTableName,arrayContains: [
            ChatRoomDto.CodingKeys.membersIDS.rawValue: [userId.uuidString]
        ])
    }
    
    func getGroupChatRoom(for chatRoomID: UUID) async throws -> ChatRoomDto? {
        try await databaseGet.getSingle(tableName: chatRoomTableName,
                                        conditionsWithSingleValue: [
                                            ChatRoomDto.CodingKeys.id.rawValue: chatRoomID,
                                            ChatRoomDto.CodingKeys.isGroup.rawValue:true
                                        ])
    }
    
    func getOneToOneChatRoom(for membersIDS:[UUID]) async throws -> ChatRoomDto? {
        try await databaseGet.getSingle(tableName: chatRoomTableName,
                                        conditionsWithSingleValue: [ChatRoomDto.CodingKeys.isGroup.rawValue:false],
                                        conditionsWithMutipleValues: [ChatRoomDto.CodingKeys.membersIDS.rawValue:membersIDS])
    }
    
    func getRoomImageData(chatRoomID: UUID) async throws -> Data? {
        try await supabaseMediaManager.getImage(storageName: chatRoomImageStorageName, id: chatRoomID)
    }
    
    func uploadRoomImageData(chatRoomID: UUID,imageData: Data) async throws {
        try await supabaseMediaManager.uploadImage(storageName: chatRoomImageStorageName, id: chatRoomID, imageData: imageData)
    }
    
    
    func updateGroupChatRoom(chatRoomDto: ChatRoomDto) async throws {
        try await databaseUpdate.update(tableName: chatRoomTableName,
                                        with: chatRoomDto,
                                        conditions: [ChatRoomDto.CodingKeys.id.rawValue:chatRoomDto.id])
    }
    
}

