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
    case profileDetails(profileUIModel: ProfileUIModel)
    
    static func == (lhs: NavigationFeedPages, rhs: NavigationFeedPages) -> Bool {
        switch (lhs, rhs) {
        case (.feedList, .feedList):
            return true
        case (.feedDetails(let lhsFeed), .feedDetails(let rhsFeed)):
            return lhsFeed.id == rhsFeed.id
        case (.profileDetails(let lhsProfile), .profileDetails(let rhsProfile)):
            return lhsProfile.id == rhsProfile.id
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
