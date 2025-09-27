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
    var authenticationService: AuthenticationRepository
    
    init(authenticationService: AuthenticationRepository) {
        self.authenticationService = authenticationService
    }
}

extension SignInUseCaseImplementation: SignInUseCase {
    
    func execute(email: String, password: String) async throws {
        
        guard isNotEmpty(string: email) else {
            throw AuthenticationError.emptyUsername
        }
        
        guard isNotEmpty(string: password) else {
            throw AuthenticationError.emptyPassword
        }
        
        try await authenticationService.SignIn(email: email, password: password)
        
        authenticationService.saveUserAuthenticationInfo(email: email, password: password)
    }
}

// create small function to check of userName or password is not empty
func isNotEmpty(string: String) -> Bool {
    return !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
}
