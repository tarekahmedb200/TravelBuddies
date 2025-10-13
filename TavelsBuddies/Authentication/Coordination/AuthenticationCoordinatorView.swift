//
//  MainCoordinatorView.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import SwiftUI

struct AuthenticationCoordinatorView: View {
    
    @EnvironmentObject var manager: AppManager
    @StateObject private var coordinator = AuthenticationCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.navigate(to: .signIn)
                .navigationDestination(for: NavigationAuthenticationPages.self) { page in
                    coordinator.navigate(to: page)
                }                
        }
    }
}
