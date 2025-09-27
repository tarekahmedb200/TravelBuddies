//
//  GetOtherProfileImage.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation


protocol GetProfileImageUseCase {
    func execute(profileID:UUID) async throws -> Data?
}

class GetProfileImageUseCaseImplementation {
    private let profileRepository:ProfileRepository
    
    init(profileRepository:ProfileRepository) {
        self.profileRepository = profileRepository
    }
}

extension GetProfileImageUseCaseImplementation: GetProfileImageUseCase {
    func execute(profileID:UUID) async throws -> Data? {
         try await self.profileRepository.getProfileImage(profileID: profileID)
    }
}
