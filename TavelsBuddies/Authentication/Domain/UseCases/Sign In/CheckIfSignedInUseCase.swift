//
//  CheckIfSignedInUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation


protocol CheckIfSignedInUseCase {
    func execute() -> Bool
}

class CheckIfSignedInUseCaseImplementation {
    var authenticationRepository: AuthenticationRepository
    
    init(authenticationRepository: AuthenticationRepository) {
        self.authenticationRepository = authenticationRepository
    }
}

extension CheckIfSignedInUseCaseImplementation: CheckIfSignedInUseCase {
    
    func execute() -> Bool {
        return self.authenticationRepository.checkIfUserIsSignedIn()
    }
}

