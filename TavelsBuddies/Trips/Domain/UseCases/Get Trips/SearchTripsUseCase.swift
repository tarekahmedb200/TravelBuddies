//
//  SearchTripsUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation


protocol SearchTripsUseCase {
    func execute(tripFilter : TripFilter) async throws -> [Trip]
}

class SearchTripsUseCaseImplementation {
    private let tripRepository: TripRepository
    
    init(tripRepository: TripRepository) {
        self.tripRepository = tripRepository
    }
}

extension SearchTripsUseCaseImplementation : SearchTripsUseCase {
    func execute(tripFilter : TripFilter) async throws -> [Trip]{
        return try await tripRepository.searchTrips(tripFilter: tripFilter)
    }
}
