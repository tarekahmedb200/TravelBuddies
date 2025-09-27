//
//  FeedCoordinationView.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation
import SwiftUI

struct FeedCoordinationView: View {
    @StateObject private var coordinator = FeedCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.navigate(to: .feedList)
                .navigationDestination(for: NavigationFeedPages.self) { page in
                    coordinator.navigate(to: page)
                }
                .fullScreenCover(item: $coordinator.fullScreenPage) { page in
                    coordinator.showFullScreenCover(page)
                }
        }
    }
}
