//
//  SignUpFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//


import Foundation

final class SignUpFactory {

    var coordinator: any AuthenticationCoordinating
    private var authenticationDependencyFactory : AuthenticationDependencyFactory
    
    init(coordinator: any AuthenticationCoordinating) {
        self.coordinator = coordinator
        self.authenticationDependencyFactory = AuthenticationDependencyFactory()
    }
    
    func getSignupView() -> SignUpView {
        return SignUpView(viewModel: self.getSignupViewModel())
    }
    
    func getSignupViewModel() -> SignUpViewModel {
        return SignUpViewModel(signupFlowUseCase: getSignupFlowUseCase(), coordinator: self.coordinator)
    }
    
    private func getSignupFlowUseCase() -> any SignupFlowUseCase {
        return SignupFlowUseCaseImplementation(signUpUseCase: getSignupUseCase(), createProfileUseCase: ProfileFactory().getCreateProfileUseCase(), uploadProfileImageUseCase: ProfileFactory().getUploadProfileImageUseCase(), authenticationRepository: authenticationDependencyFactory.getAuthenticationRepository())
    }
    
    private func getSignupUseCase() -> any SignUpUseCase {
        return SignUpUseCaseImplementation(authenticationRepository: authenticationDependencyFactory.getAuthenticationRepository())
    }
    
}
