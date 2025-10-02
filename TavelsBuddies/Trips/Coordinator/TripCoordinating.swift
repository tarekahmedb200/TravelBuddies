//
//  TripCoordinating.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation

protocol TripCoordinating : NavigationCoordinating , FullScreenCoordinating {
    func navigate(to page:NavigationTripPages) -> NavigatedCustomView
    func push(to page: NavigationTripPages)
    func popToRoot()
    
    func presentFullScreenCover(_ page: FullScreenTripPages)
    func dismissFullScreenCover()
    func showFullScreenCover(_ page: FullScreenTripPages) -> FullScreenCustomView
}
