//
//  AuthenticationRepositoryImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation


class AuthenticationRepositoryImplementation: AuthenticationRepository {
 
    var authenticationService: AuthenticationService
    var userAuthenticationInfoCacheService: UserAuthenticationInfoCacheService
    
    init(authenticationService: AuthenticationService,userAuthenticationInfoCacheService: UserAuthenticationInfoCacheService) {
        self.authenticationService = authenticationService
        self.userAuthenticationInfoCacheService = userAuthenticationInfoCacheService
    }
    
    func SignIn(email: String, password: String) async throws {
        try await authenticationService.SignIn(email: email, password: password)
    }
    
    func SignUp(email: String, password: String) async throws {
        try await authenticationService.SignUp(email: email, password: password)
    }
    
    func saveUserAuthenticationInfo(email: String, password: String) {
        let userAuthenticationInfoPersistanceDto = UserAuthenticationInfoPersistanceDto(email: email, password: password)
        userAuthenticationInfoCacheService.saveUserAuthenticationInfo(userAuthenticationInfoPersistanceDto: userAuthenticationInfoPersistanceDto)
    }
    
    func checkIfUserIsSignedIn() -> Bool {
        userAuthenticationInfoCacheService.getUserAuthenticationInfo() != nil
    }
    
    func getCurrentUserID() -> UUID? {
        authenticationService.getCurrentUserID()
    }

}
