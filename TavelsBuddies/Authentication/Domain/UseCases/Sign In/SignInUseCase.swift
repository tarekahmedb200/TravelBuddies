//
//  SignInUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation

protocol SignInUseCase {
    func execute(email: String, password: String) async throws
}


class SignInUseCaseImplementation {
    var authenticationRepository: AuthenticationRepository
    
    init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }
}

extension SignInUseCaseImplementation: SignInUseCase {
    
    func execute(email: String, password: String) async throws {
        
        guard isNotEmpty(string: email) else {
            throw AuthenticationUseCaseError.emptyUsername
        }
        
        guard isNotEmpty(string: password) else {
            throw AuthenticationUseCaseError.emptyPassword
        }
        
        try await authenticationRepository.SignIn(email: email, password: password)
        
        authenticationRepository.saveUserAuthenticationInfo(email: email, password: password)
    }
}

// create small function to check of userName or password is not empty
func isNotEmpty(string: String) -> Bool {
    return !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
}
