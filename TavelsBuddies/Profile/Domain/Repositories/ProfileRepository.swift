//
//  ProfileRepository.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation

protocol ProfileRepository {
    func create(profile: Profile) async throws
    func getProfile(id: UUID) async throws -> Profile?
    func getProfiles(ids: [UUID]) async throws -> [Profile]
    func update(id: UUID,profile: Profile) async throws
    func getProfileImage(profileID: UUID) async throws -> Data?
    func uploadProfileImage(profileImageData: Data,profileID: UUID) async throws
}
