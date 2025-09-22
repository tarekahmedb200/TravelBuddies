//
//  ProfieFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation

class ProfileFactory {
    
    
    var coordinator: Coordinating
    
    init(coordinator: Coordinating) {
        self.coordinator = coordinator
    }
    
    func getCreateProfileUseCase() -> any CreateProfileUseCase {
        return CreateProfileUseCaseImplementation(profileRepository: getProfileRepository())
    }
    
    private func getProfileRepository() -> any ProfileRepository {
        return ProfileRepositoryImplementation(profileService: getProfileService())
    }
    
    private func getProfileService() -> ProfileService {
        return SupabaseProfileServiceImplementation()
    }
}


