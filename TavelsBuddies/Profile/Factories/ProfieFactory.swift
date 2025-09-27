//
//  ProfieFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation

class ProfileFactory {
    
    // MARK: - Use Cases
    
    func getGetCurrentProfileUseCase() -> any GetCurrentProfileUseCase {
        return GetCurrentProfileUseCaseImplementation(
            profileRepository: getProfileRepository(),
            authenticationRepository: getAuthenticationRepository()
        )
    }
    
    func getGetProfilesUseCase() -> any GetProfilesUseCase {
        return GetProfilesUseCaseImplementation(
            profileRepository: getProfileRepository()
        )
    }
    
    func getUploadProfileImageUseCase() -> UploadProfileImageUseCase {
        return UploadProfileImageUseCaseImplementation(
            profileRepository: getProfileRepository()
        )
    }
    
    func getGetCurrentProfileImageUseCase() -> any GetCurrentProfileImageUseCase {
        return GetCurrentProfileImageUseCaseImplementation(
            profileRepository: getProfileRepository(),
            authenticationRepository: getAuthenticationRepository()
        )
    }
    
    func getGetCurrentProfileImagesUseCase() -> any GetProfileImageUseCase {
        return GetProfileImageUseCaseImplementation(profileRepository: getProfileRepository())
    }
    
    func getCreateProfileUseCase() -> any CreateProfileUseCase {
        return CreateProfileUseCaseImplementation(
            profileRepository: getProfileRepository()
        )
    }
    
    
    // MARK: - Repositories
    
    private func getProfileRepository() -> any ProfileRepository {
        return ProfileRepositoryImplementation(
            profileService: getProfileService(),
            authenticationService: getAuthenticationService()
        )
    }
    
    private func getAuthenticationRepository() -> any AuthenticationRepository {
        return AuthenticationRepositoryImplementation(
            authenticationService: getAuthenticationService(),
            userAuthenticationInfoCacheService: getUserAuthenticationInfoCacheService()
        )
    }
    
    
    // MARK: - Services
    
    private func getProfileService() -> ProfileService {
        return SupabaseProfileServiceImplementation()
    }
    
    private func getAuthenticationService() -> AuthenticationService {
        return SupabaseAuthenticationServiceImplementation()
    }
    
    private func getUserAuthenticationInfoCacheService() -> UserAuthenticationInfoCacheService {
        return UserDefaultsCacheService()
    }
}
