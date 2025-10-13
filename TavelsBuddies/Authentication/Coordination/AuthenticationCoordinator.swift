//
//  AppCoordinator.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation
import Combine
import SwiftUI

final class AuthenticationCoordinator: ObservableObject, AuthenticationCoordinating {
    
    @Published var path = NavigationPath()
    
    func push(to page: NavigationAuthenticationPages) {
        path.append(page)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func navigate(to page: NavigationAuthenticationPages) -> some View {
        switch page {
        case .signIn:
            SignInFactory(coordinator: self).getSignInView()
        case .signUp:
            SignUpFactory(coordinator: self).getSignupView()
        }
    }
}
