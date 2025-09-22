//
//  SignUpUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation


protocol SignUpUseCase {
    func execute(email: String, password: String) async throws
}

class SignUpUseCaseImplementation {
    var authenticationRepository: AuthenticationRepository
    
    init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }
}

extension SignUpUseCaseImplementation: SignUpUseCase {
    
    func execute(email: String, password: String) async throws {
        try await authenticationRepository.SignUp(email: email, password: password)
    }
}
