//
//  TavelsBuddiesApp.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import SwiftUI

@main
struct TavelsBuddiesApp: App {
    
    @StateObject private var manager = AppManager.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if manager.state == .isAuthenticated {
                    MainCoordinationView()
                        .transition(.move(edge: .top))
                } else {
                    AuthenticationCoordinatorView()
                        .transition(.move(edge: .bottom))
                }
            }
            .environmentObject(manager)
            .animation(.easeInOut(duration: 0.4), value: manager.state)
        }
    }
}


