//
//  TripCoordinationView.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation
import SwiftUI

struct TripCoordinationView: View {
    @StateObject private var coordinator = TripCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.navigate(to: .tripList)
                .navigationDestination(for: NavigationTripPages.self) { page in
                    coordinator.navigate(to: page)
                }
                .fullScreenCover(item: $coordinator.fullScreenPage) { page in
                    coordinator.showFullScreenCover(page)
                }
        }
    }
}
