//
//  SupabaseProfileServiceImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation


class SupabaseProfileServiceImplementation {
   
    private let databaseCreate: DatabaseCreateService
    private let databaseRead: DatabaseGetService
    private let databaseUpdate: DatabaseUpdateService
    private let supabaseMediaManager: SupabaseMediaManager
    private let profileTableName = SupabaseTableNames.profile.rawValue
    
    private let profileImageStorageName = SupabaseStorageNames.profileImages.rawValue
    
    init() {
        databaseCreate = DatabaseCreateService()
        databaseRead = DatabaseGetService()
        databaseUpdate = DatabaseUpdateService()
        supabaseMediaManager = SupabaseMediaManager()
    }
}

extension SupabaseProfileServiceImplementation : ProfileService {
    func getProfiles(ids: [UUID]) async throws -> [ProfileDto] {
        try await databaseRead.getAll(tableName: profileTableName, ids: ids)
    }
    
    func createProfile(_ profileDto: ProfileDto) async throws {
        try await databaseCreate.create(profileDto, tableName: profileTableName)
    }
    
    func getProfile(id: UUID) async throws -> ProfileDto {
        return try await databaseRead.getSingle(tableName: profileTableName, id: id)
    }
    
    func updateProfile(id:UUID,_ profileDto: ProfileDto) async throws {
        try await databaseUpdate.update(tableName: profileTableName, with: id, and: profileDto)
    }
    
    func getProfileImage(profileID: UUID) async throws -> Data? {
        try await supabaseMediaManager.getImage(storageName: profileImageStorageName, id: profileID)
    }
    
    func uploadProfileImage(profileImageData: Data, profileID: UUID) async throws {
        try await supabaseMediaManager.uploadImage(storageName: profileImageStorageName, id: profileID, imageData: profileImageData)
    }
}
