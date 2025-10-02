//
//  NavigationTripPages.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation


enum NavigationTripPages:  Equatable, Hashable , Identifiable  {
    
    var id : UUID {
        UUID()
    }
    
    case tripList
    case tripDetails(trip : TripUIModel)
    
    static func == (lhs: NavigationTripPages, rhs: NavigationTripPages) -> Bool {
        switch (lhs, rhs) {
        case (.tripList, .tripList):
            return true
        case (.tripDetails(let lhsTrip), .tripDetails(let rhsTrip)):
            return lhsTrip.id == rhsTrip.id
        default:
            return false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
