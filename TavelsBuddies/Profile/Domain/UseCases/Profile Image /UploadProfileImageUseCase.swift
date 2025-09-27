//
//  UploadProfileImageUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 26/09/2025.
//

import Foundation

protocol UploadProfileImageUseCase {
    func execute(profileImageData: Data, profileID: UUID) async throws
}

class UploadProfileImageUseCaseImplementation {
    private let profileRepository:ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
}

extension UploadProfileImageUseCaseImplementation: UploadProfileImageUseCase {
    func execute(profileImageData: Data, profileID: UUID) async throws {
        try await profileRepository.uploadProfileImage(profileImageData: profileImageData, profileID: profileID)
    }
}
