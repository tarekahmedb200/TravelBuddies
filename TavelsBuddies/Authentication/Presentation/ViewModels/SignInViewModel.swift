//
//  SignInViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation
import Combine


class SignInViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var email: String = ""
    @Published var password: String = ""
    
    private let signInUseCase: SignInUseCase
    private let coordinator: any AuthenticationCoordinating
    
    init(signInUseCase: SignInUseCase, coordinator: any AuthenticationCoordinating) {
        self.signInUseCase = signInUseCase
        self.coordinator = coordinator
    }
    
    func SignIn() async -> Bool {
        do {
            try await self.signInUseCase.execute(email: self.email, password: self.password)
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            return false
        }
    }
    
    func navigateToSignUp() {
        coordinator.push(to: .signUp)
    }
    
}
