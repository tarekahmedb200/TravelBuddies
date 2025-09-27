//
//  ProfileService.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation

protocol ProfileService {
    func createProfile(_ profileDto: ProfileDto) async throws
    func getProfile(id: UUID) async throws -> ProfileDto
    func getProfiles(ids: [UUID]) async throws -> [ProfileDto]
    func updateProfile(id:UUID,_ profileDto: ProfileDto) async throws
    func getProfileImage(profileID: UUID) async throws -> Data?
    func uploadProfileImage(profileImageData: Data, profileID: UUID) async throws
}
