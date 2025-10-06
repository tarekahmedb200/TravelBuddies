//
//  MemberTripDetailsFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 04/10/2025.
//

import Foundation

final class MemberTripDetailsFactory {
    
    var coordinator: any TripCoordinating
    var tripUIModel: TripUIModel
    
    init(coordinator: any TripCoordinating,tripUIModel: TripUIModel) {
        self.coordinator = coordinator
        self.tripUIModel = tripUIModel
    }
    
    func getMemberTripDetailsView() -> MemberTripDetailsView {
        return MemberTripDetailsView(viewModel: self.getMemberTripDetailsViewModel())
    }
    
    func getMemberTripDetailsViewModel() -> MemberTripDetailsViewModel {
        
        return MemberTripDetailsViewModel(
            tripUIModel: tripUIModel,
            getCurrentProfileUseCase: ProfileFactory().getGetCurrentProfileUseCase(),
            getProfilesUseCase: ProfileFactory().getGetProfilesUseCase(),
            joinTripUseCase: getJoinTripUseCase(),
            leaveTripUseCase: getLeaveTripUseCase(),
            getProfileImageUseCase: ProfileFactory().getGetCurrentProfileImagesUseCase(),
            getCurrentProfileImageUseCase: ProfileFactory().getGetCurrentProfileImageUseCase(),
            coordinator: self.coordinator)
    }
    
    
    private func getJoinTripUseCase() -> any JoinTripUseCase {
        return JoinTripUseCaseImplementation(updateTripUseCase: getUpdateTripUseCase(), getCurrentProfileUseCase: ProfileFactory().getGetCurrentProfileUseCase(), getTripUseCase: getGetTripUseCase())
    }
    
    private func getLeaveTripUseCase() -> any LeaveTripUseCase {
        return LeaveTripUseCaseImplementation(updateTripUseCase: getUpdateTripUseCase(), getCurrentProfileUseCase: ProfileFactory().getGetCurrentProfileUseCase(), getTripUseCase: getGetTripUseCase())
    }
    
    private func getGetTripUseCase() -> any GetTripUseCase {
        return GetTripUseCaseImplementation(tripRepository: getTripRepository())
    }
 
    private func getUpdateTripUseCase() -> any UpdateTripUseCase {
        return UpdateTripUseCaseImplementation(tripRepository: getTripRepository())
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
