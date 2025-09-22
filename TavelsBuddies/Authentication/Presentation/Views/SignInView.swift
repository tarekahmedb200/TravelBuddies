//
//  SignInView.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject var ViewModel : SignInViewModel
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 30) {
            
            VStack {
                Image(systemName: "globe")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .padding()
                
                Text("Tavels Buddies")
                    .font(.largeTitle)
                    .bold()
                    .padding()
            }
            
            VStack(alignment: .center,spacing: 30) {
                TextField("Email", text: $ViewModel.email)
                SecureField("Password", text: $ViewModel.password)
            }
            .textFieldStyle(BorderedTextFieldStyle())
            .padding()
            
            Button("Sign In") {
                ViewModel.SignIn()
            }
            .buttonStyle(PrimaryButtonStyle())
            
            HStack {
                Text("Don't have an account?")
                
                Button("Sign Up") {
                    ViewModel.navigateToSignUp()
                }
            }
        }
    }
}

#Preview {
    SignInView(ViewModel: SignInFactory(coordinator: AppCoordinator()).getSignInViewModel())
}
