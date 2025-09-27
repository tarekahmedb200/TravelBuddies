//
//  FeedLikeUIModel.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation


struct FeedLikeUIModel {
    var id : UUID = UUID()
    let profileID: UUID
    let feedID: UUID
}

extension FeedLikeUIModel {
    func toDomain() -> FeedLike {
        FeedLike(id: id, profileID: profileID, feedID: feedID)
    }
}

extension FeedLike {
    func toUIModel() -> FeedLikeUIModel {
        FeedLikeUIModel(id:id,profileID: profileID, feedID: feedID)
    }
}
