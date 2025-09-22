//
//  SupabaseProfileServiceImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation


class SupabaseProfileServiceImplementation {
   
    private let databaseCreate: DatabaseCreateService<ProfileDto>
    private let databaseRead: DatabaseGetService<ProfileDto>
    private let databaseUpdate: DatabaseUpdateService<ProfileDto>
    private let databaseDelete: DatabaseDeleteService<ProfileDto>
    
    init() {
        databaseCreate = DatabaseCreateService<ProfileDto>(tableName: SupabaseTableNames.profile.rawValue)
        databaseRead = DatabaseGetService<ProfileDto>(tableName: SupabaseTableNames.profile.rawValue)
        databaseUpdate = DatabaseUpdateService<ProfileDto>(tableName: SupabaseTableNames.profile.rawValue)
        databaseDelete = DatabaseDeleteService<ProfileDto>(tableName: SupabaseTableNames.profile.rawValue)
    }
}

extension SupabaseProfileServiceImplementation : ProfileService {
    func createProfile(_ profileDto: ProfileDto) async throws {
        try await databaseCreate.create(profileDto)
    }
    
    func getProfile(id: String) async throws -> ProfileDto {
        return try await databaseRead.get(with: id)
    }
    
    func updateProfile(id:String,_ profileDto: ProfileDto) async throws {
        try await databaseUpdate.update(with: id, and: profileDto)
    }
    
    func deleteProfile(id: String) async throws {
        try await databaseDelete.delete(with: id)
    }
}
