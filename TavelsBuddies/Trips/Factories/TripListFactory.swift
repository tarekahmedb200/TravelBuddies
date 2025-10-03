//
//  TripListFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation

final class TripListFactory {
    
    var coordinator: any TripCoordinating
    
    init(coordinator: any TripCoordinating) {
        self.coordinator = coordinator
    }
    
    func getFeedListView() -> TripListView {
        return TripListView(viewModel: self.getTripListViewModel())
    }
    
    func getTripListViewModel() -> TripListViewModel {
        
        return TripListViewModel(
            getAllTripsUseCase: getGetAllTripsUseCase(),
            searchTripsUseCase: getSearchTripsUseCase(),
            getProfilesUseCase: ProfileFactory().getGetProfilesUseCase(),
            getProfileImageUseCase: ProfileFactory().getGetCurrentProfileImagesUseCase(),
            getTripImageUseCase:getSearchTripImageUseCase(),
            coordinator: self.coordinator)
    }
 

    private func getGetAllTripsUseCase() -> any GetAllTripsUseCase {
        return GetAllTripsUseCaseImplementation(tripRepository: getTripRepository())
    }
    
    private func getSearchTripsUseCase() -> any SearchTripsUseCase {
        return SearchTripsUseCaseImplementation(tripRepository: getTripRepository())
    }
    
    private func getSearchTripImageUseCase() -> any GetTripImageUseCase {
        return GetTripImageUseCaseImplementation(tripRepository: getTripRepository())
    }
        
    private func getTripRepository() -> any TripRepository {
        return TripRepositoryImplementation(tripService: getTripServiceService())
    }
    
    private func getTripServiceService() -> TripService {
        return SupabaseTripServiceImplementation()
    }
    
}
