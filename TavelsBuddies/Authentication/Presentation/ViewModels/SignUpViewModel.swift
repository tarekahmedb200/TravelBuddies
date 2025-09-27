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
    @Published var profileImageData : Data?
    
    private let signupFlowUseCase: SignupFlowUseCase
    private let coordinator: any AppCoordinating
    
    init(signupFlowUseCase: SignupFlowUseCase ,coordinator: any AppCoordinating) {
        self.signupFlowUseCase = signupFlowUseCase
        self.coordinator = coordinator
    }
    
    func popToSignIn() {
        coordinator.popToRoot()
    }
    
    func handleSignupFlow() {
        Task {
            do {
                let profileToCreate = Profile(username: userName, description: description,address: address)
                try await self.signupFlowUseCase.execute(email: email, password: password,profile: profileToCreate,profileImageData: profileImageData)
                
                self.coordinator.presentFullScreenCover(.mainView)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
