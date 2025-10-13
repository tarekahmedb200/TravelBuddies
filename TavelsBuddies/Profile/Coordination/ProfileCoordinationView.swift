//
//  ProfileCoordinationView.swift
//  TavelsBuddies
//
//  Created by tarek on 08/10/2025.
//

import Foundation
import SwiftUI

struct ProfileCoordinationView: View {
    var firstPage: NavigationProfilePages
    var isEmbed: Bool
    @StateObject var coordinator: ProfileCoordinator
    
    var body: some View {
        if isEmbed {
            NavigationStack(path: $coordinator.path) {
                coordinator.navigate(to: firstPage)
                    .navigationDestination(for: NavigationProfilePages.self) { page in
                        coordinator.navigate(to: page)
                    }
            }
        }else {
            
            coordinator.navigate(to: firstPage)
                .navigationDestination(for: NavigationProfilePages.self) { page in
                    coordinator.navigate(to: page)
                }
            
        }
        
    }
}
