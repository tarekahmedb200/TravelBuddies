//
//  ProfileDetailsViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 08/10/2025.
//

import Foundation
import Combine

@MainActor
class ProfileDetailsViewModel : ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var profileUIModel: ProfileUIModel
    
    private let coordinator: any ProfileCoordinating
    
    init(profileUIModel: ProfileUIModel, coordinator: any ProfileCoordinating) {
        self.profileUIModel = profileUIModel
        self.coordinator = coordinator
    }
    
    func enterTripOneToOneChat() {
       // coordinator.push(to: .tripGroupChat(tripUIModel: tripUIModel, isAdmin: false))
    }
    
}





