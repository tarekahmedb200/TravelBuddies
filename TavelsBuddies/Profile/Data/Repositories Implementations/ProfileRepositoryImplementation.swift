//
//  ProfileRepositoryImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation


class ProfileRepositoryImplementation {
    private let profileService: ProfileService
    
    init(profileService: ProfileService) {
        self.profileService = profileService
    }
}

extension ProfileRepositoryImplementation: ProfileRepository {
    func create(profile: Profile) async throws {
        try await profileService.createProfile(profile.toDto())
    }
    
    func get(id: String) async throws -> Profile {
        let profileDto = try await profileService.getProfile(id: id)
        return profileDto.toDomain()
    }
    
    func update(id: String,profile: Profile) async throws {
        try await profileService.updateProfile(id: id, profile.toDto())
    }
    
    func delete(id: String) async throws {
        try await profileService.deleteProfile(id: id)
    }
}
