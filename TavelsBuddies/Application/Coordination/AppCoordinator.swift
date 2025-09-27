//
//  AppCoordinator.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation
import Combine
import SwiftUI


final class AppCoordinator: ObservableObject, AppCoordinating {
    
    @Published var path = NavigationPath()
    @Published var fullScreenPage: FullScreenAppPages?
    
    func push(to page: NavigationAppPages) {
        path.append(page)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func navigate(to page: NavigationAppPages) -> some View {
        switch page {
        case .signIn:
            SignInFactory(coordinator: self).getSignInView()
        case .signUp:
            SignUpFactory(coordinator: self).getSignupView()
        }
    }
    
    func presentFullScreenCover(_ page: FullScreenAppPages) {
        self.fullScreenPage = page
    }
    
    func dismissFullScreenCover() {
        self.fullScreenPage = nil
    }
    
    @ViewBuilder
    func showFullScreenCover(_ page: FullScreenAppPages) -> some View {
        
        switch fullScreenPage {
        case .mainView:
             MainView()
        case .none:
            EmptyView()
        }
    }
    
}
