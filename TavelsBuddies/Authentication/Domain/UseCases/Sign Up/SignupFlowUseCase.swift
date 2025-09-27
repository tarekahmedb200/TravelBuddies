//
//  SignupFlowUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation


protocol SignupFlowUseCase {
    func execute(email: String, password: String,profile: Profile, profileImageData: Data?) async throws 
}

class SignupFlowUseCaseImplementation {
    private let authenticationRepository: AuthenticationRepository
    private let signUpUseCase: SignUpUseCase
    private let uploadProfileImageUseCase: UploadProfileImageUseCase
    private let createProfileUseCase : CreateProfileUseCase
    
    init(signUpUseCase: SignUpUseCase, createProfileUseCase: CreateProfileUseCase, uploadProfileImageUseCase: UploadProfileImageUseCase,authenticationRepository: AuthenticationRepository) {
        self.signUpUseCase = signUpUseCase
        self.createProfileUseCase = createProfileUseCase
        self.authenticationRepository = authenticationRepository
        self.uploadProfileImageUseCase = uploadProfileImageUseCase
    }
}

extension SignupFlowUseCaseImplementation : SignupFlowUseCase {
    func execute(email: String, password: String,profile: Profile, profileImageData: Data?) async throws {
        try await signUpUseCase.execute(email: email, password: password)
        
        var profile = profile
        profile.id = authenticationRepository.getCurrentUserID()
        try await createProfileUseCase.execute(profile: profile)
        
        if let profileImageData , let profileID = profile.id {
            try await uploadProfileImageUseCase.execute(profileImageData: profileImageData, profileID: profileID)
        }
    }
}


