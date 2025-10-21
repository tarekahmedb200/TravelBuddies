//
//  ObserveNewlyInsertedFeedsUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 27/09/2025.
//

import Foundation

protocol ObserveFeedsChangesUseCase {
    func execute() -> AsyncStream<(Feed,CrudObservationOperationType)>
}

class ObserveFeedsChangesUseCaseImplementation {
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
}

extension ObserveFeedsChangesUseCaseImplementation : ObserveFeedsChangesUseCase {
    func execute() -> AsyncStream<(Feed,CrudObservationOperationType)> {
        return feedRepository.observeFeedChanges()
    }
}
