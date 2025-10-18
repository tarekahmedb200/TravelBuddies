//
//  FeedCommentService.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation

protocol FeedCommentService {
    func getFeedComments(feedID: UUID) async throws -> [FeedCommentDto]
    func getSingleFeedComment(feedCommentID: UUID) async throws -> FeedCommentDto?
    func updateFeedComment(feedCommentDto: FeedCommentDto) async throws
    func deleteFeedComment(feedCommentID: UUID) async throws
    func createFeedComment(feedCommentDto: FeedCommentDto) async throws
    func observeNewlyAddedFeedCommentsChanges() -> AsyncStream<FeedCommentDto>
}
