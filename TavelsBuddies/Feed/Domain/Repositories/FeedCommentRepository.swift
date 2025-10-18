//
//  FeedCommentRepository.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation


protocol FeedCommentRepository {
    func getFeedComments(feedID: UUID) async throws -> [FeedComment]
    func getSingleFeedComment(feedCommentID: UUID) async throws -> FeedComment?
    func createFeedComment(feedComment: FeedComment) async throws
    func updateFeedComment(feedComment: FeedComment) async throws
    func deleteFeedComment(feedCommentID: UUID) async throws
    func observeNewlyAddedFeedCommentsChanges() -> AsyncStream<FeedComment>
}
