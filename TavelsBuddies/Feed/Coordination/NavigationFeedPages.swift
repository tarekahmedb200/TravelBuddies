//
//  FeedPages.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation

enum NavigationFeedPages:  Equatable, Hashable , Identifiable  {
    
    var id : UUID {
        UUID()
    }
    
    case feedList
    case feedDetails(feed : FeedUIModel)
    
    static func == (lhs: NavigationFeedPages, rhs: NavigationFeedPages) -> Bool {
        switch (lhs, rhs) {
        case (.feedList, .feedList):
            return true
        case (.feedDetails(let lhsFeed), .feedDetails(let rhsFeed)):
            return lhsFeed.id == rhsFeed.id
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .feedList:
            hasher.combine(self)
        case .feedDetails:
            hasher.combine(self)
        }
    }
}
