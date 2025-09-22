//
//  SignupFlowUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation


protocol SignupFlowUseCase {
    func execute(email: String, password: String, profile: Profile) async throws
}

class SignupFlowUseCaseImplementation {
    private let authenticationRepository: AuthenticationRepository
    private let signUpUseCase: SignUpUseCase
    private let createProfileUseCase : CreateProfileUseCase
    
    init(signUpUseCase: SignUpUseCase, createProfileUseCase: CreateProfileUseCase,authenticationRepository: AuthenticationRepository) {
        self.signUpUseCase = signUpUseCase
        self.createProfileUseCase = createProfileUseCase
        self.authenticationRepository = authenticationRepository
    }
}

extension SignupFlowUseCaseImplementation : SignupFlowUseCase {
    func execute(email: String, password: String,profile: Profile) async throws {
        try await signUpUseCase.execute(email: email, password: password)
        
        var profile = profile
        profile.id = authenticationRepository.getCurrentUserID()
        print(profile.id)
        try await createProfileUseCase.execute(profile: profile)
    }
}


