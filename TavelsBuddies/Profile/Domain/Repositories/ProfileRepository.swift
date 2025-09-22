//
//  ProfileRepository.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation


protocol ProfileRepository {
    func create(profile: Profile) async throws
    func get(id: String) async throws -> Profile
    func update(id: String,profile: Profile) async throws
    func delete(id: String) async throws
}
