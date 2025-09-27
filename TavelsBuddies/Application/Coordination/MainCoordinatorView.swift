//
//  MainCoordinatorView.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import SwiftUI

struct MainCoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.navigate(to: .signIn)
                .navigationDestination(for: NavigationAppPages.self) { page in
                    coordinator.navigate(to: page)
                }
                .fullScreenCover(item: $coordinator.fullScreenPage) { page in
                    coordinator.showFullScreenCover(page)
                }
                
        }
    }
}
