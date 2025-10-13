//
//  SignUpViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation
import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var userName: String = ""
    @Published var description: String = ""
    @Published var address: String = ""
    @Published var gender: Gender = .male
    @Published var selectedCountryCode: CountryCode = .getCurrentCountryCode()
    @Published var mobileNumber: String = ""
    @Published var country: String = ""
    @Published var birthDate: Date = Date()
    @Published var profileImageData: Data?
    
    private let signupFlowUseCase: SignupFlowUseCase
    private let coordinator: any AuthenticationCoordinating
    
    init(signupFlowUseCase: SignupFlowUseCase, coordinator: any AuthenticationCoordinating) {
        self.signupFlowUseCase = signupFlowUseCase
        self.coordinator = coordinator
    }
    
    func popToSignIn() {
        coordinator.popToRoot()
    }
    
    @MainActor
    func handleSignupFlow() async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await signupFlowUseCase.execute(
                email: email,
                password: password,
                username: userName,
                description: description.isEmpty ? nil : description,
                address: address,
                gender: gender,
                mobileNumber: mobileNumber,
                countryCodeNumber: selectedCountryCode.countryCode,
                country: country,
                birthDate: birthDate,
                profileImageData: profileImageData
            )
            
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}

