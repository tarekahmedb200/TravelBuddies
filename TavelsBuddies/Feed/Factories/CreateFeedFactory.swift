//
//  CreateFeedFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation


 final class CreateFeedFactory {
    
    private var coordinator: any FeedCoordinating
    private let dependencies: FactoryDependency
    
    init(coordinator: any FeedCoordinating, dependencies: FactoryDependency = FactoryDependency()) {
        self.coordinator = coordinator
        self.dependencies = dependencies
    }
    
    func getCreateFeedView() -> CreateFeedView {
        return CreateFeedView(viewModel: self.getCreateFeedViewModel())
    }
    
    func getCreateFeedViewModel() -> CreateFeedViewModel {
        return CreateFeedViewModel(
            createFeedUseCase: dependencies.makeCreateFeedUseCase(),
            getCurrentProfileUseCase: dependencies.profileFactory.getGetCurrentProfileUseCase(),
            coordinator: self.coordinator)
    }
    
}
