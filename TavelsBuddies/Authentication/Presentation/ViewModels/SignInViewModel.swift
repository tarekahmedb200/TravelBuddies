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
    private let checkIfSignedInUseCase: CheckIfSignedInUseCase
    private let coordinator: any AppCoordinating
    
    init(signInUseCase: SignInUseCase, checkIfSignedInUseCase: CheckIfSignedInUseCase, coordinator: any AppCoordinating) {
        self.signInUseCase = signInUseCase
        self.checkIfSignedInUseCase = checkIfSignedInUseCase
        self.coordinator = coordinator
    }
    
    func SignIn() {
        Task {
            do {
                try await self.signInUseCase.execute(email: self.email, password: self.password)
                self.coordinator.presentFullScreenCover(.mainView)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func navigateToSignUp() {
        coordinator.push(to: .signUp)
    }
    
    func navigateToHomeIfSignedIn() {
        if self.checkIfSignedInUseCase.execute() {
            self.coordinator.presentFullScreenCover(.mainView)
        }
    }
    
}
