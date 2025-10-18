//
//  FeedCommentUIModel.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation

struct FeedCommentUIModel: Identifiable {
    let id: UUID
    let comment: String
    let createdAt: String
    let feedID: UUID
    var profileUIModel: ProfileUIModel? = nil
}

extension FeedCommentUIModel {
    static var mockData: [FeedCommentUIModel] {
        [
            FeedCommentUIModel(
                id: UUID(),
                comment: "This trip looks amazing! Where exactly did you go?",
                createdAt: Date().toString(),
                feedID: UUID(),
                profileUIModel : ProfileUIModel.mockData[0]
            ),
            FeedCommentUIModel(
                id: UUID(),
                comment: "I want to join next time 😍",
                createdAt: Date().addingTimeInterval(-3600).toString(),
                feedID: UUID()
            ),
            FeedCommentUIModel(
                id: UUID(),
                comment: "The photos are so beautiful, thanks for sharing!",
                createdAt: Date().addingTimeInterval(-7200).toString(),
                feedID: UUID()
            ),
            FeedCommentUIModel(
                id: UUID(),
                comment: "How long was the hike?",
                createdAt: Date().addingTimeInterval(-10800).toString(),
                feedID: UUID()
            ),
            FeedCommentUIModel(
                id: UUID(),
                comment: "This makes me want to plan my own trip soon ✈️",
                createdAt: Date().addingTimeInterval(-14400).toString(),
                feedID: UUID()
            )
        ]
    }
}


extension FeedComment {
    func toUIModel() -> FeedCommentUIModel {
        return FeedCommentUIModel(id: id, comment: comment, createdAt: createdAt.toString(), feedID: feedID)
    }
}


