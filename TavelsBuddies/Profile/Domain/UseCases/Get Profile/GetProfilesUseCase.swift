//
//  GetOtherProfilesUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation

protocol GetProfilesUseCase {
    func execute(profileIDs:[UUID]) async throws -> [Profile]
}

class GetProfilesUseCaseImplementation {
    private let profileRepository:ProfileRepository
    
    init(profileRepository:ProfileRepository) {
        self.profileRepository = profileRepository
    }
}

extension GetProfilesUseCaseImplementation: GetProfilesUseCase {
    func execute(profileIDs:[UUID]) async throws -> [Profile] {
        try await profileRepository.getProfiles(ids: profileIDs)
    }
}
