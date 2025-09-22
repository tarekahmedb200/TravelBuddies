//
//  SignUpFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//


import Foundation

final class SignUpFactory {

    var coordinator: Coordinating
    
    init(coordinator: Coordinating) {
        self.coordinator = coordinator
    }
    
    func getSignupView() -> SignUpView {
        return SignUpView(ViewModel: self.getSignupViewModel())
    }
    
    func getSignupViewModel() -> SignUpViewModel {
        return SignUpViewModel(signupFlowUseCase: getSignupFlowUseCase(), coordinator: self.coordinator)
    }
    
    private func getSignupFlowUseCase() -> any SignupFlowUseCase {
        return SignupFlowUseCaseImplementation(signUpUseCase: getSignupUseCase(), createProfileUseCase: ProfileFactory(coordinator: self.coordinator).getCreateProfileUseCase(), authenticationRepository: getAuthenticationRepository())
    }
    
    private func getSignupUseCase() -> any SignUpUseCase {
        return SignUpUseCaseImplementation(authenticationRepository: getAuthenticationRepository())
    }
    
    private func getAuthenticationRepository() -> any AuthenticationRepository {
        return AuthenticationRepositoryImplementation(
            authenticationService: getAuthenticationService(),
            userAuthenticationInfoCacheService: getUserAuthenticationInfoCacheService()
        )
    }
    
    private func getAuthenticationService() -> AuthenticationService {
        return SupabaseAuthenticationServiceImplementation()
    }
    
    private func getUserAuthenticationInfoCacheService() -> UserAuthenticationInfoCacheService {
        return UserDefaultsCacheService()
    }
}
