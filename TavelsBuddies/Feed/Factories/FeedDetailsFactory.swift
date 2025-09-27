//
//  FeedDetailsFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation


final class FeedDetailsFactory {
    
    var coordinator: any FeedCoordinating
    var feedUIModel: FeedUIModel
    
    init(coordinator: any FeedCoordinating,feedUIModel: FeedUIModel) {
        self.coordinator = coordinator
        self.feedUIModel = feedUIModel
    }
    
    func getFeedDetailsView() -> FeedDetailsView {
        return FeedDetailsView(viewModel: self.getFeedFeedDetailsViewModel())
    }
    
    func getFeedFeedDetailsViewModel() -> FeedDetailViewModel {
        
        return FeedDetailViewModel(
            feedUIModel: self.feedUIModel,
            createFeedCommentUseCase: getCreateFeedCommentUseCase(),
            getAllFeedCommentsUseCase: getGetAllFeedCommentsUseCase(),
            getProfilesUseCase: ProfileFactory().getGetProfilesUseCase(),
            likeFeedUseCase: getLikeFeedUseCase(),
            getCurrentProfileUseCase: ProfileFactory().getGetCurrentProfileUseCase(),
            unlikeFeedUseCase: getUnLikeFeedUseCase(),
            getCurrentProfileImageUseCase: ProfileFactory().getGetCurrentProfileImageUseCase(),
            getProfileImageUseCase: ProfileFactory().getGetCurrentProfileImagesUseCase(),
            observeNewlyInsertedFeedCommentsUseCase: getObserveNewlyInsertedFeedCommentsUseCase(),
            coordinator: self.coordinator)
    }
    
    private func getObserveNewlyInsertedFeedCommentsUseCase() -> any ObserveNewlyInsertedFeedCommentsUseCase {
        return ObserveNewlyInsertedFeedCommentsUseCaseImplementation(feedRepository: getFeedRepository())
    }
    
    private func getCreateFeedCommentUseCase() -> any CreateFeedCommentUseCase {
        return CreateFeedCommentUseCaseImplementation(feedRepository: getFeedRepository(), authenticationRepository: getAuthenticationRepository())
    }
    
    private func getGetAllFeedCommentsUseCase() -> any GetAllFeedCommentsUseCase {
        return GetAllFeedCommentsUseCaseImplementation(feedRepository: getFeedRepository())
    }
    
    private func getLikeFeedUseCase() -> any LikeFeedUseCase {
        return LikeFeedUseCaseImplementation(feedRepository: getFeedRepository())
    }
    
    private func getUnLikeFeedUseCase() -> any UnLikeFeedUseCase {
        return UnLikeFeedUseCaseImplementation(feedRepository: getFeedRepository())
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


