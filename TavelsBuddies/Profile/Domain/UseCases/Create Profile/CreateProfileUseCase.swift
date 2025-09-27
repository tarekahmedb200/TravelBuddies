//
//  CreateProfileUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation

protocol CreateProfileUseCase {
    func execute(profile:Profile) async throws
}

class CreateProfileUseCaseImplementation {
    private let profileRepository:ProfileRepository
    
    init(profileRepository:ProfileRepository) {
        self.profileRepository = profileRepository
    }
}

extension CreateProfileUseCaseImplementation: CreateProfileUseCase {
    func execute(profile: Profile) async throws {
        
        guard isNotEmpty(string: profile.username) else {
            throw ProfileCrudOperationError.emptyUserName
        }
        
        guard isNotEmpty(string: profile.address) else {
            throw ProfileCrudOperationError.emptyAddress
        }
        
        try await self.profileRepository.create(profile: profile)
    }
    
    private func isNotEmpty(string: String) -> Bool {
        return !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
