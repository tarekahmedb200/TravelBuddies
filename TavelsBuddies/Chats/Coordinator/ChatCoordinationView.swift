//
//  ChatCoordinationView.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation
import SwiftUI

struct ChatCoordinationView: View {
    @StateObject private var coordinator = ChatCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.navigate(to: .chatDashboard)
                .navigationDestination(for: NavigationChatPages.self) { page in
                    coordinator.navigate(to: page)
                }
                .fullScreenCover(item: $coordinator.fullScreenPage) { page in
                    coordinator.showFullScreenCover(page)
                }
        }
    }
}
