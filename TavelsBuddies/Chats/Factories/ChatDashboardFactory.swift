//
//  ChatDashboardFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation

final class ChatDashboardFactory {
    
    var coordinator: any ChatCoordinating
    
    init(coordinator: any ChatCoordinating) {
        self.coordinator = coordinator
    }
    
    func getChatDashBoardView() -> ChatDashBoardView {
        return ChatDashBoardView(viewModel: self.getChatDashboardViewModel())
    }
    
    func getChatDashboardViewModel() -> ChatDashboardViewModel {
        return ChatDashboardViewModel(
            getCurrentProfileAllChatRoomsUseCase: getGetCurrentProfileAllChatRoomsUseCase(),
            getChatRoomImageUseCase: getGetCurrentProfileUseCase(),
            coordinator: self.coordinator)
    }
    
    private func getGetCurrentProfileUseCase() -> any GetChatRoomImageUseCase {
        return GetChatRoomImageUseCaseImplementation(chatRepository: getChatRepository())
    }
    
    private func getGetCurrentProfileAllChatRoomsUseCase() -> any GetCurrentProfileAllChatRoomsUseCase {
        return GetCurrentProfileAllChatRoomsUseCaseImplementation(chatRepository: getChatRepository(), authenticationRepository: getAuthenticationRepository())
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
