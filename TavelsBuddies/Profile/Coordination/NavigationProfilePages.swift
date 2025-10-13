//
//  NavigationProfilePages.swift
//  TavelsBuddies
//
//  Created by tarek on 08/10/2025.
//

import Foundation

enum NavigationProfilePages:  Equatable, Hashable , Identifiable  {
    
    var id : UUID {
        UUID()
    }
    
    case currentProfileDetails
    case profileDetails(profileUIModel : ProfileUIModel)
    case oneToOneChat(profileUIModel : ProfileUIModel)
    
    static func == (lhs: NavigationProfilePages, rhs: NavigationProfilePages) -> Bool {
        switch (lhs, rhs) {
        case (.currentProfileDetails, .currentProfileDetails):
            return true
        case (.profileDetails(let lhsProfile), .profileDetails(let rhsProfile)):
            return lhsProfile.id == rhsProfile.id
        case (.oneToOneChat(let lhsProfile), .oneToOneChat(let rhsProfile)):
            return lhsProfile.id == rhsProfile.id
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
