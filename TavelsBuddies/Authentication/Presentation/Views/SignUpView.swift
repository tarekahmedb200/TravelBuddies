//
//  SignUpView.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import SwiftUI

struct SignUpView: View {
    
    @StateObject var ViewModel : SignUpViewModel
    
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
                    .textFieldStyle(BorderedTextFieldStyle())
                SecureField("Password", text: $ViewModel.password)
                    .textFieldStyle(BorderedTextFieldStyle())
                
                TextField("UserName", text: $ViewModel.userName)
                    .textFieldStyle(BorderedTextFieldStyle())
                
                TextField("Description", text: $ViewModel.description)
                    .textFieldStyle(BorderedTextFieldStyle(minHeight: 70))
                
                TextField("Address", text: $ViewModel.address)
                    .textFieldStyle(BorderedTextFieldStyle())
            }
            .padding()
            
            
            Button("Sign Up") {
                ViewModel.handleSignupFlow()
            }
            .buttonStyle(PrimaryButtonStyle())
            
            HStack {
                Text("Already have an account?")
                
                Button("Sign In") {
                    ViewModel.popToSignIn()
                }
            }
            
        }
    }
}

#Preview {
    SignUpView(ViewModel: SignUpFactory(coordinator: AppCoordinator()).getSignupViewModel())
}


