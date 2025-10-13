//
//  CreateProfileUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation

protocol CreateProfileUseCase {
    func execute(
        id: UUID,
        username: String,
        description: String?,
        address: String,
        gender: Gender,
        mobileNumber: String,
        countryCodeNumber : String,
        country: String,
        birthDate: Date
    ) async throws
}

final class CreateProfileUseCaseImplementation: CreateProfileUseCase {
    
    private let profileRepository: ProfileRepository
    
    init(profileRepository: ProfileRepository) {
        self.profileRepository = profileRepository
    }
    
    func execute(
        id: UUID,
        username: String,
        description: String?,
        address: String,
        gender: Gender,
        mobileNumber: String,
        countryCodeNumber : String,
        country: String,
        birthDate: Date
    ) async throws {
        
//        // Step 1: Validate required fields
//        try validate(
//            username: username,
//            address: address,
//            mobileNumber: mobileNumber,
//            country: country,
//            birthDate: birthDate
//        )
        
        // Step 2: Create profile model
        let profile = Profile(
            id: id,
            username: username,
            description: description,
            address: address,
            gender: gender,
            mobileNumber: mobileNumber,
            countryCodeNumber : countryCodeNumber,
            country: country,
            birthDate: birthDate
        )
        
        // Step 3: Persist profile
        try await profileRepository.create(profile: profile)
    }
    
    // MARK: - Validation
    private func validate(
        username: String,
        address: String,
        mobileNumber: String,
        country: String,
        birthDate: Date
    ) throws {
        
        if !isNotEmpty(username) {
            throw ProfileUseCaseError.emptyUserName
        }
        
        if !isNotEmpty(address) {
            throw ProfileUseCaseError.emptyAddress
        }
        
        if !isNotEmpty(mobileNumber) {
            throw ProfileUseCaseError.emptyMobileNumber
        }
        
        if !isNotEmpty(country) {
            throw ProfileUseCaseError.emptyCountry
        }
        
        let minimumAllowedAge = 13
        let age = Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0
        if age < minimumAllowedAge {
            throw ProfileUseCaseError.invalidBirthDate
        }
    }
    
    private func isNotEmpty(_ string: String) -> Bool {
        !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
