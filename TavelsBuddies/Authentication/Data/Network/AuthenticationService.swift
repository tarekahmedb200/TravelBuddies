//
//  AuthenticationService.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation


protocol AuthenticationService {
    func SignIn(email: String, password: String) async throws
    func SignUp(email: String, password: String) async throws
    func getCurrentUserID() -> String?
}
