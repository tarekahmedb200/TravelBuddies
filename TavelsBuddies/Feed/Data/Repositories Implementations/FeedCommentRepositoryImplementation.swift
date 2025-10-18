//
//  FeedCommentRepositoryImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation



class FeedCommentRepositoryImplementation {
    private let feedCommentService: FeedCommentService
    
    init(feedCommentService: FeedCommentService) {
        self.feedCommentService = feedCommentService
    }
}

extension FeedCommentRepositoryImplementation: FeedCommentRepository {
    
    func getFeedComments(feedID: UUID) async throws -> [FeedComment] {
        try await feedCommentService.getFeedComments(feedID: feedID).map {
            return $0.toDomain()
        }
    }
    
    func getSingleFeedComment(feedCommentID: UUID) async throws -> FeedComment? {
        try await feedCommentService.getSingleFeedComment(feedCommentID: feedCommentID)?.toDomain()
    }
    
    func createFeedComment(feedComment: FeedComment) async throws {
        try await feedCommentService.createFeedComment(feedCommentDto: feedComment.toDto())
    }
    
    func updateFeedComment(feedComment: FeedComment) async throws {
        try await feedCommentService.updateFeedComment(feedCommentDto: feedComment.toDto())
    }
    
    func deleteFeedComment(feedCommentID: UUID) async throws {
        try await feedCommentService.deleteFeedComment(feedCommentID: feedCommentID)
    }
    
    func observeNewlyAddedFeedCommentsChanges() -> AsyncStream<FeedComment> {
        let feedCommentStream = feedCommentService.observeNewlyAddedFeedCommentsChanges()
        
        return AsyncStream { continuation in
            Task {
                for await feedCommentDto in feedCommentStream {
                    continuation.yield(feedCommentDto.toDomain())
                }
                continuation.finish()
            }
        }
    }
    
}
