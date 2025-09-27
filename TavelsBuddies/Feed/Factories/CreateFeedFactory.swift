//
//  CreateFeedFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation


 final class CreateFeedFactory {
    
    private var coordinator: any FeedCoordinating
    private let profileFactory : ProfileFactory
    
    init(coordinator: any FeedCoordinating) {
        self.coordinator = coordinator
        self.profileFactory = ProfileFactory()
    }
    
    func getCreateFeedView() -> CreateFeedView {
        return CreateFeedView(viewModel: self.getCreateFeedViewModel())
    }
    
    func getCreateFeedViewModel() -> CreateFeedViewModel {
        return CreateFeedViewModel(
            createFeedUseCase: getCreateFeedUseCase(),
            getCurrentProfileUseCase: profileFactory.getGetCurrentProfileUseCase(),
            coordinator: self.coordinator)
    }
    
     private func getCreateFeedUseCase() -> any CreateFeedUseCase {
         return CreateFeedUseCaseImplementation(feedRepository: getFeedRepository(), authenticationRepository: getAuthenticationRepository())
     }
    
    private func getAllFeedLikesUseCase() -> any GetAllFeedsLikesUseCase {
       return GetAllFeedsLikesUseCaseImplementation(feedRepository: getFeedRepository())
    }
    
    private func getFeedMediaUseCase() -> any GetFeedMediaUseCase {
        return GetFeedMediaUseCaseImplementation(feedRepository: getFeedRepository())
    }
    
    private func getFeedRepository() -> any FeedRepository {
        return FeedRepositoryImplementation(feedService: getAuthenticationService(), authenticationService: getAuthenticationService())
    }
    
    private func getAuthenticationService() -> FeedService {
        return SupabaseFeedServiceImplementation()
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
