//
//  ObserveNewlyInsertedFeedCommentsUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 27/09/2025.
//

import Foundation


protocol ObserveNewlyInsertedFeedCommentsUseCase {
    func execute() -> AsyncStream<FeedComment>
}

class ObserveNewlyInsertedFeedCommentsUseCaseImplementation {
    private let feedRepository: FeedRepository
    
    init(feedRepository: FeedRepository) {
        self.feedRepository = feedRepository
    }
}

extension ObserveNewlyInsertedFeedCommentsUseCaseImplementation : ObserveNewlyInsertedFeedCommentsUseCase {
    func execute() -> AsyncStream<FeedComment> {
        return feedRepository.observeNewlyAddedFeedCommentsChanges()
    }
}
