//
//  GetCurrentProfileImageUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation


protocol GetCurrentProfileImageUseCase {
    func execute() async throws -> Data?
}

class GetCurrentProfileImageUseCaseImplementation {
    private let profileRepository:ProfileRepository
    private let authenticationRepository:AuthenticationRepository
    
    init(profileRepository: ProfileRepository, authenticationRepository: AuthenticationRepository) {
        self.profileRepository = profileRepository
        self.authenticationRepository = authenticationRepository
    }
}

extension GetCurrentProfileImageUseCaseImplementation: GetCurrentProfileImageUseCase {
    func execute() async throws -> Data? {
        
        guard let profileID = self.authenticationRepository.getCurrentUserID() else {
            throw FeedRepositoryError.unknownError
        }
        
        return try await self.profileRepository.getProfileImage(profileID: profileID)
    }
    
}
