//
//  TripCoordinator.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation
import SwiftUI
import Combine


final class TripCoordinator: ObservableObject, TripCoordinating {
    
    @Published var path = NavigationPath()
    @Published var fullScreenPage: FullScreenTripPages?
    
    func push(to page: NavigationTripPages) {
        path.append(page)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func navigate(to page: NavigationTripPages) -> some View {
        switch page {
        case .tripList:
            TripListFactory(coordinator: self).getFeedListView()
        case .tripDetails(let tripUIModel,let isAdmin):
            if isAdmin {
                AdminTripDetailsFactory(coordinator: self, tripUIModel: tripUIModel).getAdminTripDetailsView()
            }else {
                MemberTripDetailsFactory(coordinator: self, tripUIModel: tripUIModel).getMemberTripDetailsView()
            }
        }
    }
    
    func presentFullScreenCover(_ page: FullScreenTripPages) {
        self.fullScreenPage = page
    }
    
    func dismissFullScreenCover() {
        self.fullScreenPage = nil
    }
    
    @ViewBuilder
    func showFullScreenCover(_ page: FullScreenTripPages) -> some View {
        
        switch fullScreenPage {
        case .createTrip:
            CreateTripFactory(coordinator: self).getCreateTripView()
        case .none:
            EmptyView()
        }
    }
}
