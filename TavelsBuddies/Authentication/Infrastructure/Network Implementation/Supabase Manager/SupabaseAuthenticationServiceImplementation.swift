//
//  SupabaseAuthenticationServiceImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation


class SupabaseAuthenticationServiceImplementation : AuthenticationService {
    
    private var supabaseAuthentication: SupabaseAuthentication
    
    init() {
        self.supabaseAuthentication = SupabaseAuthentication()
    }
    
    func SignIn(email: String, password: String) async throws {
        try await supabaseAuthentication.SignIn(email: email, password: password)
    }
    
    func SignUp(email: String, password: String) async throws {
        try await supabaseAuthentication.SignUp(email: email, password: password)
    }
    
    func getCurrentUserID() -> String? {
        supabaseAuthentication.getCurrentUserID()
    }
}
