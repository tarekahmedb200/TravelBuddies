//
//  FeedCoordinator.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation
import SwiftUI
import Combine


final class FeedCoordinator: ObservableObject, FeedCoordinating {
    
    @Published var path = NavigationPath()
    @Published var fullScreenPage: FullScreenFeedPages?
    
    func push(to page: NavigationFeedPages) {
        path.append(page)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func navigate(to page: NavigationFeedPages) -> some View {
        switch page {
        case .feedList:
            FeedListFactory(coordinator: self).getFeedListView()
        case .feedDetails(let feedUIModel):
            
            FeedDetailsFactory(coordinator: self, feedUIModel: feedUIModel).getFeedDetailsView()
        case .profileDetails(profileUIModel: let profileUIModel):
            ProfileMainCoordinatorFactory(firstPage: .profileDetails(profileUIModel: profileUIModel),path: path).getProfileCoordinationView()
        }
    }
    
    func presentFullScreenCover(_ page: FullScreenFeedPages) {
        self.fullScreenPage = page
    }
    
    func dismissFullScreenCover() {
        self.fullScreenPage = nil
    }
    
    @ViewBuilder
    func showFullScreenCover(_ page: FullScreenFeedPages) -> some View {
        
        switch fullScreenPage {
        case .createFeed:
            CreateFeedFactory(coordinator: self).getCreateFeedView()
        case .updateFeed(let feedUIModel, let onDismiss):
            UpdateFeedFactory(coordinator: self, feedUIModel: feedUIModel).getUpdateFeedView()
                .onDisappear(perform: onDismiss)
        case .none:
            EmptyView()
        }
    }
}
