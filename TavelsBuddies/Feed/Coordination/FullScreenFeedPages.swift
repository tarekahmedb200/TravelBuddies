//
//  FullScreenFeedPages.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation

enum FullScreenFeedPages: Identifiable, Equatable, Hashable {
    
    case createFeed
    case updateFeed(feed: FeedUIModel, onDismiss: () -> Void)
    
    var id: UUID {
        switch self {
        case .createFeed:
            return UUID()
        case .updateFeed(let feed, _):
            return feed.id
        }
    }
    
    // Custom Equatable ignoring the closure
    static func == (lhs: FullScreenFeedPages, rhs: FullScreenFeedPages) -> Bool {
        switch (lhs, rhs) {
        case (.createFeed, .createFeed):
            return true
        case let (.updateFeed(lFeed, _), .updateFeed(rFeed, _)):
            return lFeed.id == rFeed.id
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}

