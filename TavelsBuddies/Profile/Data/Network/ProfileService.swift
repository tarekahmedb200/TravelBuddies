//
//  ProfileService.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation

protocol ProfileService {
    func createProfile(_ profileDto: ProfileDto) async throws
    func getProfile(id: String) async throws -> ProfileDto
    func updateProfile(id:String,_ profileDto: ProfileDto) async throws
    func deleteProfile(id: String) async throws
}
