//
//  AdminTripDetailsFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 05/10/2025.
//

import Foundation

final class AdminTripDetailsFactory {
    
    var coordinator: any TripCoordinating
    var tripUIModel: TripUIModel
    
    init(coordinator: any TripCoordinating,tripUIModel: TripUIModel) {
        self.coordinator = coordinator
        self.tripUIModel = tripUIModel
    }
    
    func getAdminTripDetailsView() -> AdminTripDetailsView {
        return AdminTripDetailsView(viewModel: self.getAdminTripDetailsViewModel())
    }
    
    func getAdminTripDetailsViewModel() -> AdminTripDetailsViewModel {
        
        return AdminTripDetailsViewModel(
            tripUIModel: tripUIModel,
            getCurrentProfileUseCase: ProfileFactory().getGetCurrentProfileUseCase(),
            getProfilesUseCase: ProfileFactory().getGetProfilesUseCase(),
            getProfileImageUseCase: ProfileFactory().getGetCurrentProfileImagesUseCase(),
            getCurrentProfileImageUseCase: ProfileFactory().getGetCurrentProfileImageUseCase(),
            deleteTripUseCase: getDeleteTripUseCase(),
            
            coordinator: self.coordinator)
    }
    
    
    private func getDeleteTripUseCase() -> any DeleteTripUseCase {
        return DeleteTripUseCaseImplementation(tripRepository: getTripRepository())
    }
    
    private func getTripRepository() -> any TripRepository {
        return TripRepositoryImplementation(tripService: getTripServiceService())
    }
    
    private func getTripServiceService() -> TripService {
        return SupabaseTripServiceImplementation()
    }
}
