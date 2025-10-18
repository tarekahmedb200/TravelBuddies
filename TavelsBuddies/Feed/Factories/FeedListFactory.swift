//
//  FeedListFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation


final class FeedListFactory {
    
    var coordinator: any FeedCoordinating
    private let dependencies: FactoryDependency
    
    init(coordinator: any FeedCoordinating, dependencies: FactoryDependency = FactoryDependency()) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }
    
    func getFeedListView() -> FeedListView {
        // NOTE: If FeedListView requires onEdit/onDelete, we’ll add them here once you share its initializer.
        return FeedListView(viewModel: self.getFeedListViewModel())
    }
    
    func getFeedListViewModel() -> FeedListViewModel {
        
        return FeedListViewModel(
            getAllFeedsUseCase: dependencies.makeGetAllFeedsUseCase(),
            getAllFeedLikesUseCase: dependencies.makeGetAllFeedsLikesUseCase(),
            likeFeedUseCase: dependencies.makeLikeFeedUseCase(),
            unlikeFeedUseCase: dependencies.makeUnLikeFeedUseCase(),
            getProfilesUseCase:  dependencies.profileFactory.getGetProfilesUseCase(),
            getCurrentProfileUseCase:  dependencies.profileFactory.getGetCurrentProfileUseCase(),
            getProfileImageUseCase: dependencies.profileFactory.getGetCurrentProfileImagesUseCase(),
            observeNewlyInsertedFeedsUseCase: dependencies.makeObserveNewlyInsertedFeedsUseCase(),
            getFeedMediaDatasUseCase: dependencies.makeFeedMediaDatasUseCase(),
            getActualFeedMediaUseCase: dependencies.makeGetActualFeedMediaUseCase(),
            coordinator: self.coordinator)
    }
    
}
