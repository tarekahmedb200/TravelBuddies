//
//  SupabaseAuthentication.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation
import Supabase

class SupabaseAuthentication {
    
    private var supabaseManager: SupabaseManager
    private var authClient : AuthClient?
    
    init() {
        self.supabaseManager = SupabaseManager()
        self.authClient = supabaseManager.getClient()?.auth
    }
    
    func SignIn(email: String, password: String) async throws {
        try await authClient?.signIn(email: email, password: password)
    }
    
    func SignUp(email: String, password: String) async throws {
        try await authClient?.signUp(email: email, password: password)
    }
    
    func signOut() async throws {
        try await authClient?.signOut()
    }
    
    func getCurrentUserID() -> UUID? {
        return authClient?.currentUser?.id
    }
}
