//
//  UpdateFeedFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 20/10/2025.
//

import Foundation

final class UpdateFeedFactory {
    
    private var coordinator: any FeedCoordinating
    private let dependencies: FactoryDependency
    private let feedUIModel: FeedUIModel
    
    init(coordinator: any FeedCoordinating,dependencies: FactoryDependency = FactoryDependency(), feedUIModel: FeedUIModel) {
        self.coordinator = coordinator
        self.dependencies = dependencies
        self.feedUIModel = feedUIModel
    }
    
    func getUpdateFeedView() -> UpdateFeedView {
        return UpdateFeedView(viewModel: self.getUpdateFeedViewModel())
    }
    
    func getUpdateFeedViewModel() -> UpdateFeedViewModel {
        return UpdateFeedViewModel(
            feedUIModel: self.feedUIModel,
            updateFeedUseCase: dependencies.makeUpdateFeedUseCase(),
            getCurrentProfileUseCase: dependencies.profileFactory.getGetCurrentProfileUseCase(),
            coordinator: self.coordinator
        )
    }
    
}
