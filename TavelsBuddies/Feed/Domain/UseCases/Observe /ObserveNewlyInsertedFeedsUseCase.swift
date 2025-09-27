//
//  ObserveNewlyInsertedFeedsUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 27/09/2025.
//

import Foundation

protocol ObserveNewlyInsertedFeedsUseCase {
    func execute() -> AsyncStream<Feed>
}

class ObserveNewlyInsertedFeedsUseCaseImplementation {
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
}

extension ObserveNewlyInsertedFeedsUseCaseImplementation : ObserveNewlyInsertedFeedsUseCase {
    func execute() -> AsyncStream<Feed> {
        return feedRepository.observeNewlyAddedFeedChanges()
    }
}
