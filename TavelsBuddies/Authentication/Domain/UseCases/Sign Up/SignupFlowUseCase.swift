//
//  SignupFlowUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation


protocol SignupFlowUseCase {
    func execute(
        email: String,
        password: String,
        username: String,
        description: String?,
        address: String,
        gender: Gender,
        mobileNumber: String,
        countryCodeNumber : String,
        country: String,
        birthDate: Date,
        profileImageData: Data?
    ) async throws
}

final class SignupFlowUseCaseImplementation: SignupFlowUseCase {
    
    private let authenticationRepository: AuthenticationRepository
    private let signUpUseCase: SignUpUseCase
    private let uploadProfileImageUseCase: UploadProfileImageUseCase
    private let createProfileUseCase: CreateProfileUseCase
    
    init(
        signUpUseCase: SignUpUseCase,
        createProfileUseCase: CreateProfileUseCase,
        uploadProfileImageUseCase: UploadProfileImageUseCase,
        authenticationRepository: AuthenticationRepository
    ) {
        self.signUpUseCase = signUpUseCase
        self.createProfileUseCase = createProfileUseCase
        self.uploadProfileImageUseCase = uploadProfileImageUseCase
        self.authenticationRepository = authenticationRepository
    }
    
    
    func execute(
        email: String,
        password: String,
        username: String,
        description: String?,
        address: String,
        gender: Gender,
        mobileNumber: String,
        countryCodeNumber : String,
        country: String,
        birthDate: Date,
        profileImageData: Data?
    ) async throws {
        
        try await signUpUseCase.execute(email: email, password: password)
        
        guard let userID = authenticationRepository.getCurrentUserID() else {
            throw ProfileUseCaseError.failedToGetUserID
        }
    
        try await withThrowingTaskGroup(of: Void.self) { group in
            // Create profile task
            group.addTask {
                try await self.createProfileUseCase.execute(
                    id: userID,
                    username: username,
                    description: description,
                    address: address,
                    gender: gender,
                    mobileNumber: mobileNumber,
                    countryCodeNumber: countryCodeNumber,
                    country: country,
                    birthDate: birthDate
                )
            }
            
            // Upload image task (if available)
            if let profileImageData {
                group.addTask {
                    if let compressedData = await ImageCompressor.resizeAndCompress(profileImageData) {
                        try await self.uploadProfileImageUseCase.execute(
                            profileImageData: compressedData,
                            profileID: userID
                        )
                    }
                }
            }
            
            // Wait for all parallel tasks to complete
            try await group.waitForAll()
        }
    }
}



