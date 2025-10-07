//
//  ChatRoomViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation
import Combine

@MainActor
class ChatRoomViewModel : ObservableObject {
    
    @Published var chatMessageUIModels = [ChatMessageUIModel]()
    @Published var chatRoomUIModel : ChatRoomUIModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var message: String = ""
    
    private var getOrCreateOneToOneChatRoomUseCase: GetOrCreateOneToOneChatRoomUseCase?
    private var getOrCreateGroupChatRoomUseCase: GetOrCreateGroupChatRoomUseCase?
    
    private let getChatRoomMessagesUseCase: GetChatRoomMessagesUseCase
    private let sendMessageUseCase: SendMessageUseCase
    private let observeMessagesUseCase: ObserveMessagesUseCase
    
    private let getProfilesUseCase : GetProfilesUseCase
    private let getProfileImageUseCase : GetProfileImageUseCase
    
    private let getCurrentProfileUseCase : GetCurrentProfileUseCase
    
    private let coordinator: any NavigationCoordinating & FullScreenCoordinating
    
    private var profileUIModelCache: [UUID: ProfileUIModel] = [:]
    private var profilesImagesCache: [UUID: Data] = [:]
    private var currentPofile : Profile?
    
    private var oneToOneProfileUIModel: ProfileUIModel?
    private var tripUIModel: TripUIModel?
    
    
    convenience init(chatRoomUIModel:ChatRoomUIModel,getChatRoomMessagesUseCase: GetChatRoomMessagesUseCase, sendMessageUseCase: SendMessageUseCase, observeMessagesUseCase: ObserveMessagesUseCase, getProfilesUseCase: GetProfilesUseCase, getProfileImageUseCase: GetProfileImageUseCase,
                     getCurrentProfileUseCase : GetCurrentProfileUseCase, coordinator: any NavigationCoordinating & FullScreenCoordinating) {
        
        self.init(getChatRoomMessagesUseCase: getChatRoomMessagesUseCase, sendMessageUseCase: sendMessageUseCase, observeMessagesUseCase: observeMessagesUseCase, getProfilesUseCase: getProfilesUseCase, getProfileImageUseCase: getProfileImageUseCase,getCurrentProfileUseCase: getCurrentProfileUseCase, coordinator: coordinator)
        
        self.chatRoomUIModel = chatRoomUIModel
        
        Task {
            await loadChatMessages()
            await observeNewlyInsertedFeeds()
        }
    }
    
    
    convenience init(oneToOneProfileUIModel: ProfileUIModel,getChatRoomMessagesUseCase: GetChatRoomMessagesUseCase, sendMessageUseCase: SendMessageUseCase, observeMessagesUseCase: ObserveMessagesUseCase, getProfilesUseCase: GetProfilesUseCase, getProfileImageUseCase: GetProfileImageUseCase,
                     getCurrentProfileUseCase : GetCurrentProfileUseCase,getOrCreateOneToOneChatRoomUseCase: GetOrCreateOneToOneChatRoomUseCase, coordinator: any NavigationCoordinating & FullScreenCoordinating) {
        
        self.init(getChatRoomMessagesUseCase: getChatRoomMessagesUseCase, sendMessageUseCase: sendMessageUseCase, observeMessagesUseCase: observeMessagesUseCase, getProfilesUseCase: getProfilesUseCase, getProfileImageUseCase: getProfileImageUseCase,getCurrentProfileUseCase: getCurrentProfileUseCase, coordinator: coordinator)
        
        self.oneToOneProfileUIModel = oneToOneProfileUIModel
        self.getOrCreateOneToOneChatRoomUseCase = getOrCreateOneToOneChatRoomUseCase
        
        Task {
            await getOrCreateOneToOneChat()
            await loadChatMessages()
            await observeNewlyInsertedFeeds()
        }
        
    }
    
    
    convenience init(tripUIModel: TripUIModel,getChatRoomMessagesUseCase: GetChatRoomMessagesUseCase, sendMessageUseCase: SendMessageUseCase, observeMessagesUseCase: ObserveMessagesUseCase, getProfilesUseCase: GetProfilesUseCase, getProfileImageUseCase: GetProfileImageUseCase,
                     getCurrentProfileUseCase : GetCurrentProfileUseCase,getOrCreateGroupChatRoomUseCase: GetOrCreateGroupChatRoomUseCase, coordinator: any NavigationCoordinating & FullScreenCoordinating) {
        
        self.init(getChatRoomMessagesUseCase: getChatRoomMessagesUseCase, sendMessageUseCase: sendMessageUseCase, observeMessagesUseCase: observeMessagesUseCase, getProfilesUseCase: getProfilesUseCase, getProfileImageUseCase: getProfileImageUseCase,getCurrentProfileUseCase: getCurrentProfileUseCase, coordinator: coordinator)
        
        self.tripUIModel = tripUIModel
        self.getOrCreateGroupChatRoomUseCase = getOrCreateGroupChatRoomUseCase
        
        Task {
            await getOrCreateTripGroupChat()
            await loadChatMessages()
            await observeNewlyInsertedFeeds()
        }
    }
    
    
    init(getChatRoomMessagesUseCase: GetChatRoomMessagesUseCase, sendMessageUseCase: SendMessageUseCase, observeMessagesUseCase: ObserveMessagesUseCase, getProfilesUseCase: GetProfilesUseCase, getProfileImageUseCase: GetProfileImageUseCase,
         getCurrentProfileUseCase : GetCurrentProfileUseCase, coordinator: any NavigationCoordinating & FullScreenCoordinating) {
        self.getChatRoomMessagesUseCase = getChatRoomMessagesUseCase
        self.sendMessageUseCase = sendMessageUseCase
        self.observeMessagesUseCase = observeMessagesUseCase
        self.getProfilesUseCase = getProfilesUseCase
        self.getProfileImageUseCase = getProfileImageUseCase
        self.getCurrentProfileUseCase = getCurrentProfileUseCase
        
        self.coordinator = coordinator
        
        getCurrentProfile()
    }
    
    func loadChatMessages() async {
       
            do {
                
                guard let chatRoomUIModelID = chatRoomUIModel?.id  else {
                    return
                }
                
                let sortedChatMessages = try await getChatRoomMessagesUseCase.execute(in: chatRoomUIModelID).sorted { $0.createdAt < $1.createdAt }
                chatMessageUIModels = sortedChatMessages.map { $0.toUIModel() }
                
                try await handleNewMessages(sortedChatMessages)
            } catch {
                print(error)
                print(error.localizedDescription)
                errorMessage = error.localizedDescription
            }
    }
    
    func getOrCreateTripGroupChat() async {
        guard let tripUIModel = tripUIModel ,
              let adminID = tripUIModel.adminUIModel?.id else {
            return
        }
        
        do {
            
            let groupChatMembersIDS = (tripUIModel.profileIDS + [adminID])
            chatRoomUIModel = try await getOrCreateGroupChatRoomUseCase?.execute(chatRoomID: tripUIModel.id, name: tripUIModel.title, memberIDs: groupChatMembersIDS).toUIModel()
            
            chatRoomUIModel?.chatRoomImageData = tripUIModel.tripImageData
            
        } catch  {
            print(error)
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    
    }
    
    func getOrCreateOneToOneChat() async {
        guard let oneToOneProfileUIModel = self.oneToOneProfileUIModel,
              let currentPofileID = self.currentPofile?.id else {
            return
        }
        
        do {
            var groupChatMembersIDS = [oneToOneProfileUIModel.id,currentPofileID]
            chatRoomUIModel = try await getOrCreateOneToOneChatRoomUseCase?.execute(memberIDs: groupChatMembersIDS).toUIModel()
            chatRoomUIModel?.oneToOneProfileUIModel = oneToOneProfileUIModel
        } catch  {
            print(error)
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    }
    
    
    func sendMessage() {
        Task {
            do {
                
                guard let chatRoomUIModelID = chatRoomUIModel?.id  else {
                    return
                }
                
                try await sendMessageUseCase.execute(roomID: chatRoomUIModelID, text: message)
                message = ""
            }catch {
                print(error)
                print(error.localizedDescription)
                errorMessage  = error.localizedDescription
            }
        }
    }
    
    func observeNewlyInsertedFeeds() async {
        
        guard let chatRoomUIModelID = chatRoomUIModel?.id  else {
            return
        }
        
        do {
            for await chatMessage in observeMessagesUseCase.execute(chatRoomId: chatRoomUIModelID ) {
                let chatMessageUIModel = chatMessage.toUIModel()
                chatMessageUIModels.insert(chatMessageUIModel, at: chatMessageUIModels.count)
                try await handleNewMessages([chatMessage])
            }
        } catch  {
            print(error)
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
    }
    
    func getCurrentProfile() {
        Task {
            do {
                currentPofile = try await getCurrentProfileUseCase.execute()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func handleNewMessages(_ messages: [ChatMessage]) async throws  {
        try await updateTheCache(messages)
        updateChatMessageUIModels(messages)
    }
    
    fileprivate func updateTheCache(_ messages: [ChatMessage]) async throws {
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            
            group.addTask {
                try await self.fillProfileUIModelCache(messages)
            }
            
            group.addTask {
                try await self.fillProfilesImageCache(messages)
            }
            
            try await group.waitForAll()
        }
    }
    
    private func fillProfileUIModelCache(_ messages: [ChatMessage]) async throws {
        
        let profileIds = Array(
            Set(
                messages.map { $0.senderID }.filter { profileUIModelCache[$0] == nil  }
            )
        )
        
        guard !profileIds.isEmpty else {return }
        
        let newProfiles = try await getProfilesUseCase.execute(profileIDs: profileIds)
        for profile in newProfiles {
            if let profileID = profile.id {
                profileUIModelCache[profileID] = profile.toUIModel()
            }
        }
    }
    
    private func fillProfilesImageCache(_ messages: [ChatMessage]) async throws {
        
        
        let profileIds = Array(
            Set(
                messages.map { $0.senderID }.filter { profileUIModelCache[$0] == nil  }
            )
        )
        
        guard !profileIds.isEmpty else {return }

        try await withThrowingTaskGroup(of: (UUID, Data?).self) { group in
            for id in profileIds {
                group.addTask {
                    let data = try? await self.getProfileImageUseCase.execute(profileID: id)
                    return (id, data)
                }
            }

            for try await (id, data) in group {
                if let data {
                    profilesImagesCache[id] = data
                }
            }
        }
    }
    
    private func updateChatMessageUIModels(_ messages: [ChatMessage]) {
        for message in messages {
            if let index = chatMessageUIModels.firstIndex(where: { $0.id == message.id }) {
                chatMessageUIModels[index].profileUIModel = profileUIModelCache[message.senderID]
                chatMessageUIModels[index].profileUIModel?.profileImageData = profilesImagesCache[message.senderID]
            }
        }
        
        
    }
    
}


extension ChatRoomViewModel {
    
}




