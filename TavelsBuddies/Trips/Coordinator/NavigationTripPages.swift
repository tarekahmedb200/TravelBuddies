//
//  NavigationTripPages.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation


enum NavigationTripPages:  Equatable, Hashable , Identifiable  {
    
    var id: UUID {
        UUID()
    }
    
    case tripList
    case tripDetails(tripUIModel : TripUIModel,isAdmin:Bool)
    case tripGroupChat(tripUIModel : TripUIModel,isAdmin:Bool)
    
    static func == (lhs: NavigationTripPages, rhs: NavigationTripPages) -> Bool {
        switch (lhs, rhs) {
        case (.tripList, .tripList):
            return true
        case (.tripDetails(let lhsTrip,_), .tripDetails(let rhsTrip,_)):
            return lhsTrip.id == rhsTrip.id
        case (.tripGroupChat(let lhsTrip,_), .tripGroupChat(let rhsTrip,_)):
            return lhsTrip.id == rhsTrip.id
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
