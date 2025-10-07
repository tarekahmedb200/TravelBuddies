//
//  NavigationChatPages.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation


enum NavigationChatPages:  Equatable, Hashable , Identifiable  {
    
    var id : UUID {
        UUID()
    }
    
    case chatDashboard
    case chatRoom(chatRoomUIModel: ChatRoomUIModel)
    
    static func == (lhs: NavigationChatPages, rhs: NavigationChatPages) -> Bool {
        switch (lhs, rhs) {
        case (.chatDashboard, .chatDashboard):
            return true
        case (.chatRoom(let lhsTrip), .chatRoom(let rhsTrip)):
            return lhsTrip.id == rhsTrip.id
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
