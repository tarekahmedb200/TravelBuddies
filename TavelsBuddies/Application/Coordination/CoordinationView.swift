//
//  ContentView.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .SignIn)
                .navigationDestination(for: AppPages.self) { page in
                    coordinator.build(page: page)
                }
        }
    }
}
