//
//  MainView.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation
import SwiftUI

struct MainCoordinationView: View {
    
    @EnvironmentObject var appManager: AppManager
    
    var body: some View {
        TabView {
            FeedCoordinationView()
                .tabItem {
                    Label("Feed", systemImage: "house.fill")
                }

            TripCoordinationView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            ReelsView()
                .tabItem {
                    Label("Reels", systemImage: "play.rectangle.fill")
                }

            ChatCoordinationView()
                .tabItem {
                    Label("Chat", systemImage: "bubble.left.and.bubble.right.fill")
                }

        }
    }
}

struct ReelsView: View {
    
    @EnvironmentObject var appManager: AppManager
    
    var body: some View {
        Button("Sign Out") {
            appManager.signOut()
        }
    }
}


// MARK: - Preview
#Preview {
    MainCoordinationView()
}

