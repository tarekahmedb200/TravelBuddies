//
//  FeedUIModel.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation
import SwiftUI

struct FeedUIModel: Identifiable {
    var id: UUID
    var content: String
    var createAt: String
    var profileUIModel: ProfileUIModel? = nil
    var isLikedByCurrentProfile: Bool = false
    var likesCount: Int = 0
}

extension FeedUIModel {
    static var mockData = [
        FeedUIModel(id: UUID(), content: "hello11",createAt: Date().toString(),profileUIModel: ProfileUIModel.mockData[0]),
        FeedUIModel(id: UUID(), content: "hello22", createAt: Date().toString()),
        FeedUIModel(id: UUID(), content: "hello33",createAt: Date().toString()),
        FeedUIModel(id: UUID(), content: "hello44" ,createAt: Date().toString())
    ]
}

extension Feed {
    func toUImodel() -> FeedUIModel {
        FeedUIModel(id: id, content: self.content, createAt: createdAt.toString())
    }
}
