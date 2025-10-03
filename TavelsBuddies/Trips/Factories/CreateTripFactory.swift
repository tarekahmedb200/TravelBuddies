//
//  CreateTripFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 03/10/2025.
//

import Foundation

final class CreateTripFactory {
    
    var coordinator: any TripCoordinating
    
    init(coordinator: any TripCoordinating) {
        self.coordinator = coordinator
    }
    
    func getCreateTripView() -> CreateTripView {
        return CreateTripView(viewModel: self.getCreateTripViewModel())
    }
    
    func getCreateTripViewModel() -> CreateTripViewModel {
        
        return CreateTripViewModel(createTripFlowUseCase: getCreateTripFlowUseCase())
    }
    
    private func getCreateTripFlowUseCase() -> any CreateTripFlowUseCase {
        return CreateTripFlowUseCaseImplementation(createTripUseCase: getCreateTripUseCase(), uploadTripImageUseCase: getUploadTripImageUseCase(), authenticationRepository: getAuthenticationRepository())
    }
 
    private func getUploadTripImageUseCase() -> any UploadTripImageUseCase {
        return UploadTripImageUseCaseImplementation(tripRepository: getTripRepository())
    }
    
    private func getCreateTripUseCase() -> any CreateTripUseCase {
        return CreateTripUseCaseImplementation(tripRepository: getTripRepository(), authenticationRepository: getAuthenticationRepository())
    }
    
    private func getTripRepository() -> any TripRepository {
        return TripRepositoryImplementation(tripService: getTripServiceService())
    }
    
    private func getTripServiceService() -> TripService {
        return SupabaseTripServiceImplementation()
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
