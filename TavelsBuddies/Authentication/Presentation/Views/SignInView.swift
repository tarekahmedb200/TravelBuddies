//
//  SignInView.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import SwiftUI

struct SignInView: View {
    
    @StateObject var viewModel: SignInViewModel
    @EnvironmentObject var manager: AppManager
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case email, password
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                
                // MARK: - Logo & Header
                headerSection
                    .padding(.top, 60)
                    .padding(.bottom, 50)
                
                // MARK: - Form Fields
                formSection
                    .padding(.horizontal, 24)
                
                // MARK: - Sign In Button
                signInButton
                    .padding(.horizontal, 24)
                    .padding(.top, 30)
                
                // MARK: - Sign Up Navigation
                signUpNavigationSection
                    .padding(.top, 24)
                
                Spacer(minLength: 40)
            }
        }
        .ignoresSafeArea(.keyboard)
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "globe")
                    .font(.system(size: 50))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(spacing: 8) {
                Text("Travel Buddies")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Connect with travelers worldwide")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var formSection: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(BorderedTextFieldStyle())
                .textInputAutocapitalization(.never)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit { focusedField = .password }
            
            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(BorderedTextFieldStyle())
                .textContentType(.password)
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
                .onSubmit { handleSignIn() }
        }
    }
    
    private var signInButton: some View {
        Button {
            handleSignIn()
        } label: {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
            } else {
                Text("Sign In")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(viewModel.isLoading || !isFormValid)
    }
    
    private var signUpNavigationSection: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .foregroundColor(.secondary)
            
            Button("Sign Up") {
                viewModel.navigateToSignUp()
            }
            .fontWeight(.semibold)
        }
        .font(.footnote)
    }
    
    // MARK: - Helper Methods
    
    private var isFormValid: Bool {
        !viewModel.email.isEmpty && !viewModel.password.isEmpty
    }
    
    private func handleSignIn() {
        focusedField = nil // Dismiss keyboard
        Task {
            let success = await viewModel.SignIn()
            if success {
                manager.signIn()
            }
        }
    }
}

#Preview {
    SignInView(viewModel: SignInFactory(coordinator: AuthenticationCoordinator()).getSignInViewModel())
        .environmentObject(AppManager.shared)
}
