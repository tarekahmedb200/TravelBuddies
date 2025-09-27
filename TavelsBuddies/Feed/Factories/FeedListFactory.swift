//
//  FeedListFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation


final class FeedListFactory {
    
    var coordinator: any FeedCoordinating
    
    init(coordinator: any FeedCoordinating) {
        self.coordinator = coordinator
    }
    
    func getFeedListView() -> FeedListView {
        return FeedListView(viewModel: self.getFeedListViewModel())
    }
    
    func getFeedListViewModel() -> FeedListViewModel {
        
        return FeedListViewModel(
            getAllFeedsUseCase: getAllFeedsUseCase(),
            getAllFeedLikesUseCase: getAllFeedLikesUseCase(),
            likeFeedUseCase: getLikeFeedUseCase(),
            unlikeFeedUseCase: getUnLikeFeedUseCase(),
            getFeedMediaUseCase: getFeedMediaUseCase(),
            getProfilesUseCase:  ProfileFactory().getGetProfilesUseCase(),
            getCurrentProfileUseCase:  ProfileFactory().getGetCurrentProfileUseCase(),
            getProfileImageUseCase: ProfileFactory().getGetCurrentProfileImagesUseCase(),
            observeNewlyInsertedFeedsUseCase: getObserveNewlyInsertedFeedsUseCase(),
            coordinator: self.coordinator)
    }
    
    private func getObserveNewlyInsertedFeedsUseCase() -> any ObserveNewlyInsertedFeedsUseCase {
        return ObserveNewlyInsertedFeedsUseCaseImplementation(feedRepository: getFeedRepository())
    }
    
    private func getLikeFeedUseCase() -> any LikeFeedUseCase {
        return LikeFeedUseCaseImplementation(feedRepository: getFeedRepository())
    }
    
    private func getUnLikeFeedUseCase() -> any UnLikeFeedUseCase {
        return UnLikeFeedUseCaseImplementation(feedRepository: getFeedRepository())
    }
    
    private func getAllFeedsUseCase() -> any GetAllFeedsUseCase {
        return GetAllFeedsUseCaseImplementation(feedRepository: getFeedRepository())
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
