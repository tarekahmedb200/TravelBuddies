//
//  ProfileRepositoryImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation


class ProfileRepositoryImplementation {
    private let profileService: ProfileService
    private let authenticationService: AuthenticationService
    
    init(profileService: ProfileService, authenticationService: AuthenticationService) {
        self.profileService = profileService
        self.authenticationService = authenticationService
    }
}

extension ProfileRepositoryImplementation: ProfileRepository {
    
    func getProfiles(ids: [UUID]) async throws -> [Profile] {
        try await profileService.getProfiles(ids: ids).map {
            $0.toDomain()
        }
    }
    
    func create(profile: Profile) async throws {
        try await profileService.createProfile(profile.toDto())
    }
    
    func getProfile(id: UUID) async throws -> Profile {
        let profileDto = try await profileService.getProfile(id: id)
        return profileDto.toDomain()
    }
    
    func update(id: UUID,profile: Profile) async throws {
        try await profileService.updateProfile(id: id, profile.toDto())
    }
        
    func getProfileImage(profileID: UUID) async throws -> Data? {
        try await profileService.getProfileImage(profileID: profileID)
    }
    
    func uploadProfileImage(profileImageData: Data, profileID: UUID) async throws {
        try await profileService.uploadProfileImage(profileImageData: profileImageData,profileID: profileID)
    }

}
