//
//  GetCurrentUserProfileUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation

protocol GetCurrentProfileUseCase {
    func execute() async throws -> Profile
}

class GetCurrentProfileUseCaseImplementation {
    private let profileRepository:ProfileRepository
    private let authenticationRepository:AuthenticationRepository
    
    init(profileRepository: ProfileRepository, authenticationRepository: AuthenticationRepository) {
        self.profileRepository = profileRepository
        self.authenticationRepository = authenticationRepository
    }
}

extension GetCurrentProfileUseCaseImplementation: GetCurrentProfileUseCase {
    func execute() async throws -> Profile {
        
        guard let profileID = self.authenticationRepository.getCurrentUserID() else {
            throw FeedRepositoryError.unknownError
        }
        
        return try await profileRepository.getProfile(id: profileID)
    }
}
