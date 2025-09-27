//
//  SignInFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation

final class SignInFactory {
    
    var coordinator: any AppCoordinating
    
    init(coordinator: any AppCoordinating) {
        self.coordinator = coordinator
    }
    
    func getSignInView() -> SignInView {
        return SignInView(ViewModel: self.getSignInViewModel())
    }
    
    func getSignInViewModel() -> SignInViewModel {
        return SignInViewModel(
            signInUseCase: getSignInUseCase(),
            checkIfSignedInUseCase: getCheckIfSignedInUseCase(),
            coordinator: self.coordinator
        )
    }
    
    private func getSignInUseCase() -> any SignInUseCase {
        return SignInUseCaseImplementation(
            authenticationService: getAuthenticationRepository()
        )
    }
    
    private func getCheckIfSignedInUseCase() -> any CheckIfSignedInUseCase {
        return CheckIfSignedInUseCaseImplementation(
            authenticationRepository: getAuthenticationRepository()
        )
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
