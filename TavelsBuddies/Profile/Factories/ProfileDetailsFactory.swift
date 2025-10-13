//
//  ProfileDetailsFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 08/10/2025.
//

import Foundation

final class ProfileDetailsFactory {
    
    var coordinator: any ProfileCoordinating
    var profileUIModel: ProfileUIModel
    
    init(coordinator: any ProfileCoordinating,profileUIModel: ProfileUIModel) {
        self.coordinator =  coordinator
        self.profileUIModel = profileUIModel
    }
    
    func getProfileDetailsView() -> ProfileDetailsView {
        return ProfileDetailsView(viewModel: getProfileDetailsViewModel())
    }
    
    func getProfileDetailsViewModel() -> ProfileDetailsViewModel {
        return ProfileDetailsViewModel(profileUIModel: profileUIModel, coordinator: self.coordinator)
    }
    
}

