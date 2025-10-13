//
//  SignUpView.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import SwiftUI
import PhotosUI

struct SignUpView: View {
    
    @StateObject var viewModel: SignUpViewModel
    @EnvironmentObject var manager: AppManager
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var profileImage: Image? = nil
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case email, password, username, description, address, mobileNumber, country
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                
                // MARK: - Profile Image Picker
                profileImageSection
                
                // MARK: - Form Fields
                VStack(spacing: 20) {
                    // Personal Information
                    personalInfoSection
                    
                    // Account Details
                    accountDetailsSection
                    
                    // Contact Information
                    contactInfoSection
                }
                .padding(.horizontal)
                
                // MARK: - Sign Up Button
                signUpButton
                
                // MARK: - Navigation to Sign In
                signInNavigationSection
            }
            .padding(.vertical)
        }
        .navigationTitle("Join Travel Buddies Now!")
        .navigationBarTitleDisplayMode(.inline)
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
    
    private var profileImageSection: some View {
        PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
            VStack(spacing: 8) {
                if let profileImage = profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 2)
                        )
                        .shadow(radius: 4)
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .overlay(
                            VStack(spacing: 4) {
                                Image(systemName: "camera.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                Text("Add Photo")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                        )
                }
            }
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let newItem,
                   let data = try? await newItem.loadTransferable(type: Data.self) {
                    viewModel.profileImageData = data
                    if let uiImage = UIImage(data: data) {
                        profileImage = Image(uiImage: uiImage)
                    }
                }
            }
        }
    }
    
    private var personalInfoSection: some View {
        VStack(spacing: 16) {
            TextField("Username", text: $viewModel.userName)
                .textFieldStyle(BorderedTextFieldStyle())
                .textContentType(.name)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
                .onSubmit { focusedField = .email }
            
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
                .textContentType(.newPassword)
                .focused($focusedField, equals: .password)
                .submitLabel(.next)
                .onSubmit { focusedField = .mobileNumber }
        }
    }
    
    private var accountDetailsSection: some View {
        VStack(spacing: 16) {
            TextField("About Me", text: $viewModel.description, axis: .vertical)
                .textFieldStyle(BorderedTextFieldStyle(minHeight: 80))
                .lineLimit(3...5)
                .focused($focusedField, equals: .description)
            
            HStack {
                Text("Gender")
                    .foregroundColor(.primary)
                
                Spacer()
                
                Picker("Gender", selection: $viewModel.gender) {
                    ForEach(Gender.allCases, id: \.self) { gender in
                        Text(gender.rawValue.capitalized)
                            .tag(gender)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(.blue)
            }
            
            DatePicker("Birth Date", selection: $viewModel.birthDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .accentColor(.blue)
        }
    }
    
    private var contactInfoSection: some View {
        VStack(spacing: 16) {
            
            PhoneNumberInputView(phoneNumber: $viewModel.mobileNumber, selectedCountryCode: $viewModel.selectedCountryCode)
            
            TextField("Country", text: $viewModel.country)
                .textFieldStyle(BorderedTextFieldStyle())
                .textContentType(.countryName)
                .focused($focusedField, equals: .country)
                .submitLabel(.next)
                .onSubmit { focusedField = .address }
            
            TextField("Address", text: $viewModel.address)
                .textFieldStyle(BorderedTextFieldStyle())
                .textContentType(.fullStreetAddress)
                .focused($focusedField, equals: .address)
                .submitLabel(.done)
        }
    }
    
    private var signUpButton: some View {
        Button {
            focusedField = nil // Dismiss keyboard
            Task {
                let success = await viewModel.handleSignupFlow()
                if success {
                    manager.signIn()
                }
            }
        } label: {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 20)
            } else {
                Text("Sign Up")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(PrimaryButtonStyle())
        .disabled(viewModel.isLoading)
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private var signInNavigationSection: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .foregroundColor(.secondary)
            Button("Sign In") {
                viewModel.popToSignIn()
            }
            .fontWeight(.semibold)
        }
        .font(.footnote)
    }
}

#Preview {
    NavigationStack {
        SignUpView(viewModel: SignUpFactory(coordinator: AuthenticationCoordinator()).getSignupViewModel())
            .environmentObject(AppManager.shared)
    }
}
