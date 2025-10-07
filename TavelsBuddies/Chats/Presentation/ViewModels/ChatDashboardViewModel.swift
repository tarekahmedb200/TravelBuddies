//
//  ChatDashboardViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation
import Combine

@MainActor
class ChatDashboardViewModel: ObservableObject {
    
    @Published var chatRoomUIModels = [ChatRoomUIModel]()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let getCurrentProfileAllChatRoomsUseCase: GetCurrentProfileAllChatRoomsUseCase
    private let getChatRoomImageUseCase: GetChatRoomImageUseCase
    
    private let coordinator: any ChatCoordinating
    
    private var chatRoomImagesDictionary: [UUID: Data] = [:]
   
    init(getCurrentProfileAllChatRoomsUseCase: GetCurrentProfileAllChatRoomsUseCase, getChatRoomImageUseCase: GetChatRoomImageUseCase, coordinator: any ChatCoordinating) {
        self.getCurrentProfileAllChatRoomsUseCase = getCurrentProfileAllChatRoomsUseCase
        self.getChatRoomImageUseCase = getChatRoomImageUseCase
        self.coordinator = coordinator
    }

    func navigateToTripDetails(chatRoomUIModel:ChatRoomUIModel) {
        coordinator.push(to: .chatRoom(chatRoomUIModel: chatRoomUIModel))
    }
    
    func showCreateFeed() {
        coordinator.presentFullScreenCover(.createChatRoom)
    }
    
    func loadChatRooms() {
        Task {
            do {
                isLoading = true
                
                let chatRooms = try await getCurrentProfileAllChatRoomsUseCase.execute().sorted { $0.createdAt > $1.createdAt }
                chatRoomUIModels = chatRooms.map { $0.toUIModel() }
                
                try await updateChatRoomUIModel(chatRooms)
            } catch {
                print(error)
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    private func updateChatRoomUIModel(_ chatRooms: [ChatRoom]) async throws {
        try await fillChatRoomImagesDictionary(chatRooms)
        updateChatRoomsUIModels(chatRooms)
    }
    
    private func fillChatRoomImagesDictionary(_ chatRooms: [ChatRoom]) async throws {
        
        let chatRoomsIds = Array(
            Set(
                chatRooms.map { $0.id }
            )
        )
        
        guard !chatRoomsIds.isEmpty else { return }
        
        try await withThrowingTaskGroup(of: (UUID, Data?).self) { group in
            for id in chatRoomsIds {
                group.addTask {
                    let data = try? await self.getChatRoomImageUseCase.execute(chatRoomID: id)
                    return (id, data)
                }
            }
            
            for try await (id, data) in group {
                if let data {
                    chatRoomImagesDictionary[id] = data
                }
            }
        }
    }
    
    
    private func updateChatRoomsUIModels(_ chatRooms: [ChatRoom]) {
        for chatRoom in chatRooms {
            if let index = chatRoomUIModels.firstIndex(where: { $0.id == chatRoom.id }) {
                chatRoomUIModels[index].chatRoomImageData = chatRoomImagesDictionary[chatRoom.id]
            }
        }
    }
}
