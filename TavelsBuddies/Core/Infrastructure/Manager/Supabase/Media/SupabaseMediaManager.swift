//
//  SupabaseMediaManager.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation
import Supabase

class SupabaseMediaManager {
    private let supabaseManager: SupabaseManager
    
    init() {
        self.supabaseManager = SupabaseManager()
    }
    
    func uploadImage(storageName: String, id: UUID, imageData: Data) async throws {
        let fileName = "private/\(id.uuidString).jpg"
        
        try await supabaseManager.getClient()?.storage
            .from(storageName)
            .upload(
                fileName,
                data: imageData,
                options: FileOptions(
                    contentType: "image/jpeg"
                )
            )
    }
    
    func updateImage(storageName: String, id: UUID, imageData: Data) async throws {
        let fileName = "private/\(id.uuidString).jpg"
        
        try await supabaseManager.getClient()?.storage
            .from(storageName)
            .update(
                fileName,
                data: imageData,
                options: FileOptions(
                    contentType: "image/jpeg",
                    upsert: true
                )
            )
    }
    
    func getImage(storageName: String, id: UUID) async throws -> Data? {
        let fileName = "private/\(id.uuidString).jpg"
        
        return try await supabaseManager.getClient()?.storage
            .from(storageName)
            .download(path: fileName)
    }
    
    func deleteImage(storageName: String, id: UUID) async throws {
        let fileName = "private/\(id.uuidString).jpg"
        
        try await supabaseManager.getClient()?.storage
            .from(storageName)
            .remove(paths: [fileName])
    }
    
}
