//
//  SignInFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation

final class SignInFactory {
    
    var coordinator: any AuthenticationCoordinating
    private var authenticationDependencyFactory : AuthenticationDependencyFactory
    
    init(coordinator: any AuthenticationCoordinating) {
        self.coordinator = coordinator
        self.authenticationDependencyFactory = AuthenticationDependencyFactory()
    }
    
    func getSignInView() -> SignInView {
        return SignInView(viewModel: self.getSignInViewModel())
    }
    
    func getSignInViewModel() -> SignInViewModel {
        return SignInViewModel(
            signInUseCase: getSignInUseCase(),
            coordinator: self.coordinator
        )
    }
    
    private func getSignInUseCase() -> any SignInUseCase {
        return SignInUseCaseImplementation(
            authenticationRepository: authenticationDependencyFactory.getAuthenticationRepository()
        )
    }
    
}
