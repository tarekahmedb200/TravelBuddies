//
//  ChatRoomFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 07/10/2025.
//

import Foundation

final class ChatRoomFactory {
    
    var coordinator: any NavigationCoordinating & FullScreenCoordinating
    var chatRoomUIModel: ChatRoomUIModel?
    var profileUIModel: ProfileUIModel?
    var tripUIModel: TripUIModel?
    
    convenience init(coordinator: any NavigationCoordinating & FullScreenCoordinating,chatRoomUIModel: ChatRoomUIModel) {
        self.init(coordinator: coordinator)
        self.chatRoomUIModel = chatRoomUIModel
    }
    
    convenience init(coordinator: any NavigationCoordinating & FullScreenCoordinating,profileUIModel: ProfileUIModel) {
        self.init(coordinator: coordinator)
        self.profileUIModel = profileUIModel
    }
    
    convenience init(coordinator: any NavigationCoordinating & FullScreenCoordinating,tripUIModel: TripUIModel) {
        self.init(coordinator: coordinator)
        self.tripUIModel = tripUIModel
    }
    
    init(coordinator: any NavigationCoordinating & FullScreenCoordinating) {
        self.coordinator =  coordinator
    }
    
    func getChatRoomView() -> ChatRoomView {
        return ChatRoomView(viewModel: self.getChatRoomViewModel())
    }
    
    func getChatRoomViewModel() -> ChatRoomViewModel {
        
        var viewModel : ChatRoomViewModel
        
        if let chatRoomUIModel = self.chatRoomUIModel {
            viewModel = ChatRoomViewModel(chatRoomUIModel: chatRoomUIModel,
                                          getChatRoomMessagesUseCase: getGetChatRoomMessagesUseCase(),
                                          sendMessageUseCase: getSendMessageUseCase(),
                                          observeMessagesUseCase: getObserveMessagesUseCase(),
                                          getProfilesUseCase: ProfileFactory().getGetProfilesUseCase(),
                                          getProfileImageUseCase: ProfileFactory().getGetCurrentProfileImagesUseCase(),
                                          getCurrentProfileUseCase: ProfileFactory().getGetCurrentProfileUseCase(),
                                          coordinator: self.coordinator)
        } else if let profileUIModel = self.profileUIModel {
            viewModel = ChatRoomViewModel(oneToOneProfileUIModel: profileUIModel,
                                          getChatRoomMessagesUseCase: getGetChatRoomMessagesUseCase(),
                                          sendMessageUseCase: getSendMessageUseCase(),
                                          observeMessagesUseCase: getObserveMessagesUseCase(),
                                          getProfilesUseCase: ProfileFactory().getGetProfilesUseCase(),
                                          getProfileImageUseCase: ProfileFactory().getGetCurrentProfileImagesUseCase(),
                                          getCurrentProfileUseCase: ProfileFactory().getGetCurrentProfileUseCase(),
                                          getOrCreateOneToOneChatRoomUseCase: getGetOrCreateOneToOneChatRoomUseCase(),
                                          coordinator: self.coordinator)
        } else if let tripUIModel = self.tripUIModel {
            viewModel =  ChatRoomViewModel(tripUIModel: tripUIModel,
                                     getChatRoomMessagesUseCase: getGetChatRoomMessagesUseCase(),
                                     sendMessageUseCase: getSendMessageUseCase(),
                                     observeMessagesUseCase: getObserveMessagesUseCase(),
                                     getProfilesUseCase: ProfileFactory().getGetProfilesUseCase(),
                                     getProfileImageUseCase: ProfileFactory().getGetCurrentProfileImagesUseCase(),
                                     getCurrentProfileUseCase: ProfileFactory().getGetCurrentProfileUseCase(),
                                     prepareGroupChatRoomUseCase:getPrepareGroupChatRoomUseCase(),
                                     coordinator: self.coordinator)
        }else {
            viewModel = ChatRoomViewModel(getChatRoomMessagesUseCase: getGetChatRoomMessagesUseCase(),
                                     sendMessageUseCase: getSendMessageUseCase(),
                                     observeMessagesUseCase: getObserveMessagesUseCase(),
                                     getProfilesUseCase: ProfileFactory().getGetProfilesUseCase(),
                                     getProfileImageUseCase: ProfileFactory().getGetCurrentProfileImagesUseCase(),
                                     getCurrentProfileUseCase: ProfileFactory().getGetCurrentProfileUseCase(),
                                     coordinator: self.coordinator)
        }
        
        return viewModel
    }
    
    private func getGetOrCreateOneToOneChatRoomUseCase() -> any GetOrCreateOneToOneChatRoomUseCase {
        return GetOrCreateOneToOneChatRoomUseCaseImplementation(getOneToOneChatRoomUseCase: getOneToOneChatRoomUseCase() , createRoomUseCase: getCreateRoomUseCase())
    }
    
    private func getOneToOneChatRoomUseCase() -> any  GetOneToOneChatRoomUseCase {
        GetOneToOneChatRoomUseCaseImplementation(chatRepository: getChatRepository(), authenticationRepository: getAuthenticationRepository())
    }
    
    private func getPrepareGroupChatRoomUseCase() -> any PrepareGroupChatRoomUseCase {
        return PrepareGroupChatRoomUseCaseImplementation(getSingleGroupChatRoomUseCase: getGetSingleGroupChatRoomUseCase(), createRoomUseCase: getCreateRoomUseCase(), updateGroupChatRoomUseCase: getUpdateSingleGroupChatRoomUseCase())
    }
    
    private func getUpdateSingleGroupChatRoomUseCase() -> any UpdateSingleGroupChatRoomUseCase {
        return UpdateSingleGroupChatRoomUseCaseImplementation(chatRepository: getChatRepository())
    }
    
    private func getCreateRoomUseCase() -> any CreateRoomUseCase {
        return CreateRoomUseCaseImplementation(chatRepository: getChatRepository())
    }
    
    private func getGetSingleGroupChatRoomUseCase() -> any GetSingleGroupChatRoomUseCase {
        return GetSingleGroupChatRoomUseCaseImplementation(chatRepository: getChatRepository())
    }
    
    private func getGetChatRoomMessagesUseCase() -> any GetChatRoomMessagesUseCase {
        return GetChatRoomMessagesUseCaseImplementation(chatRepository: getChatRepository())
    }
    
    private func getSendMessageUseCase() -> any SendMessageUseCase {
        return SendMessageUseCaseImplementation(chatRepository: getChatRepository(), authenticationRepository: getAuthenticationRepository())
    }
    
    private func getObserveMessagesUseCase() -> any ObserveMessagesUseCase {
        return ObserveMessagesUseCaseImplementation(chatRepository: getChatRepository())
    }
    
    private func getChatRepository() -> any ChatRepository {
        return ChatRepositoryImplementation(chatService: getChatService())
    }
    
    private func getChatService() -> ChatService {
        return SupabaseChatServiceImplementation()
    }
    
    private func getAuthenticationRepository() -> any AuthenticationRepository {
        return AuthenticationRepositoryImplementation(
            authenticationService: getAuthenticationService(),
            userAuthenticationInfoCacheService: getUserAuthenticationInfoCacheService()
        )
    }
    
    private func getAuthenticationService() -> AuthenticationService {
        return SupabaseAuthenticationServiceImplementation()
    }
    
    private func getUserAuthenticationInfoCacheService() -> UserAuthenticationInfoCacheService {
        return UserDefaultsCacheService()
    }
}
