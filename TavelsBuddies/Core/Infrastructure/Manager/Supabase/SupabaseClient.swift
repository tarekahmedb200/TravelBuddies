//
//  SupabaseClient.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation
import Supabase

class SupabaseManager {
    
    private let client: SupabaseClient?
    
    init() {
        
        let supabaseURL = URL(string: "https://cutuxjktoaueinncldis.supabase.co")
        
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN1dHV4amt0b2F1ZWlubmNsZGlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgxNjE0NjUsImV4cCI6MjA3MzczNzQ2NX0.BIcVnj6ufXEnCr86ozHmE9ky0lDgJEJSzn33PG-COSk"
        
        if let supabaseURL = supabaseURL {
            
            self.client = SupabaseClient(
                supabaseURL: supabaseURL,
                supabaseKey: supabaseKey
            )
            
        }else {
            self.client = nil
        }
        
    }
    
    func getClient() -> SupabaseClient? {
        return client
    }
    
}
