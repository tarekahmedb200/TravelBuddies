//
//  ProfileUIModel.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation
import SwiftUI


struct ProfileUIModel: Identifiable {
    var id: UUID
    var username: String
    var description: String?
    var address: String
    var profileImageData: Data?
    
    var profileImage: Image? {
        guard let data = profileImageData,
              let uiImage = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
    
}

extension ProfileUIModel {
    static var mockData = [
        ProfileUIModel(id: UUID(), username: "tarek", description: "iOS Developer", address: "Cairo, Egypt", profileImageData: nil),
        ProfileUIModel(id: UUID(), username: "ahmed", description: "Backend Engineer", address: "Alexandria, Egypt", profileImageData: nil),
        ProfileUIModel(id: UUID(), username: "mohamed", description: "UI/UX Designer", address: "Giza, Egypt", profileImageData: nil),
        ProfileUIModel(id: UUID(), username: "khaled", description: "Product Manager", address: "Mansoura, Egypt", profileImageData: nil),
    ]
}

extension Profile {
    func toUIModel() -> ProfileUIModel {
        ProfileUIModel(
            id: id ?? UUID(),
            username: username,
            description: description,
            address: address,
            profileImageData: nil
        )
    }
}
