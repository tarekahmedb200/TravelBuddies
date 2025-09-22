//
//  AppCoordinator.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation
import Combine
import SwiftUI


protocol Coordinating {
    func push(to page: AppPages)
    func popToRoot()
}

enum AppPages: Hashable {
    case SignIn
    case SignUp
    case home
}

final class AppCoordinator: ObservableObject, Coordinating {
    @Published var path = NavigationPath()
    
    func push(to page: AppPages) {
        path.append(page)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(page: AppPages) -> some View {
        switch page {
        case .SignIn:
            SignInFactory(coordinator: self).getSignInView()
        case .SignUp:
            SignUpFactory(coordinator: self).getSignupView()
        case .home:
            Text("Home")
        }
    }
}
