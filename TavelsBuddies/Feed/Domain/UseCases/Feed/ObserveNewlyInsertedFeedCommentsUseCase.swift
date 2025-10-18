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
    private let feedCommentRepository: FeedCommentRepository
    
    init(feedCommentRepository: FeedCommentRepository) {
        self.feedCommentRepository = feedCommentRepository
    }
}

extension ObserveNewlyInsertedFeedCommentsUseCaseImplementation : ObserveNewlyInsertedFeedCommentsUseCase {
    func execute() -> AsyncStream<FeedComment> {
        return feedCommentRepository.observeNewlyAddedFeedCommentsChanges()
    }
}
