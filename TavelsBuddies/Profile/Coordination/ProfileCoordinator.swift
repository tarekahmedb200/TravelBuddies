//
//  ProfileCoordinator.swift
//  TavelsBuddies
//
//  Created by tarek on 08/10/2025.
//

import Foundation
import SwiftUI
import Combine


final class ProfileCoordinator: ObservableObject, ProfileCoordinating {
    
    @Published var path = NavigationPath()
    
    init(path: NavigationPath? = nil) {
        if let path = path {
            self.path = path
        }
    }
   
    func push(to page: NavigationProfilePages) {
        path.append(page)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func navigate(to page: NavigationProfilePages) -> some View {
        switch page {
        case .profileDetails(let profileUIModel):
            ProfileDetailsFactory(coordinator: self, profileUIModel: profileUIModel).getProfileDetailsView()
        case .oneToOneChat(let profileUIModel):
            EmptyView()
        case .currentProfileDetails:
            EmptyView()
        }
    }
    
}
