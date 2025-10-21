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
    private let dependencies: FactoryDependency
    
    init(coordinator: any FeedCoordinating,feedUIModel: FeedUIModel, dependencies: FactoryDependency = FactoryDependency()) {
        self.coordinator = coordinator
        self.feedUIModel = feedUIModel
        self.dependencies = dependencies
    }
    
    func getFeedDetailsView() -> FeedDetailsView {
        return FeedDetailsView(viewModel: self.getFeedFeedDetailsViewModel())
    }
    
    func getFeedFeedDetailsViewModel() -> FeedDetailViewModel {
        
        return FeedDetailViewModel(
            feedUIModel: self.feedUIModel,
            createFeedCommentUseCase: dependencies.makeCreateFeedCommentUseCase(),
            getAllFeedCommentsUseCase: dependencies.makeGetAllFeedCommentsUseCase(),
            getProfilesUseCase: dependencies.profileFactory.getGetProfilesUseCase(),
            likeFeedUseCase: dependencies.makeLikeFeedUseCase(),
            getCurrentProfileUseCase: dependencies.profileFactory.getGetCurrentProfileUseCase(),
            unlikeFeedUseCase: dependencies.makeUnLikeFeedUseCase(),
            getCurrentProfileImageUseCase: dependencies.profileFactory.getGetCurrentProfileImageUseCase(),
            getProfileImageUseCase: dependencies.profileFactory.getGetCurrentProfileImagesUseCase(),
            observeNewlyInsertedFeedCommentsUseCase: dependencies.makeObserveNewlyInsertedFeedCommentsUseCase(),
            // Newly required dependencies
            getSingleFeedUseCase: dependencies.makeGetSingleFeedUseCase(),
            getFeedMediaDatasUseCase: dependencies.makeFeedMediaDatasUseCase(),
            getActualFeedMediaUseCase: dependencies.makeGetActualFeedMediaUseCase(),
            getAllFeedsLikesUseCase: dependencies.makeGetAllFeedsLikesUseCase(),
            // Delete feed use case
            deleteFeedUseCase: dependencies.makeDeleteFeedUseCase(),
            coordinator: self.coordinator)
    }
    
}
