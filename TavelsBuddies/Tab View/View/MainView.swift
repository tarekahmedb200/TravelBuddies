//
//  MainView.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation
import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            FeedCoordinationView()
                .tabItem {
                    Label("Feed", systemImage: "house.fill")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            ReelsView()
                .tabItem {
                    Label("Reels", systemImage: "play.rectangle.fill")
                }

            ChatView()
                .tabItem {
                    Label("Chat", systemImage: "bubble.left.and.bubble.right.fill")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
    }
}

// MARK: - Placeholder Views

struct SearchView: View {
    var body: some View { Text("Search Screen") }
}

struct ReelsView: View {
    var body: some View { Text("Reels Screen") }
}

struct ChatView: View {
    var body: some View { Text("Chat Screen") }
}

struct ProfileView: View {
    var body: some View { Text("Profile Screen") }
}

// MARK: - Preview
#Preview {
    MainView()
}

