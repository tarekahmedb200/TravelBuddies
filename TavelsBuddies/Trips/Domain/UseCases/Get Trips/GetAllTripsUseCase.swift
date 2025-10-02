//
//  GetAllTripsUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation


protocol GetAllTripsUseCase {
    func execute() async throws -> [Trip]
}

class GetAllTripsUseCaseImplementation {
    private let tripRepository: TripRepository
    
    init(tripRepository: TripRepository) {
        self.tripRepository = tripRepository
    }
}

extension GetAllTripsUseCaseImplementation : GetAllTripsUseCase {
    func execute() async throws -> [Trip] {
        return try await tripRepository.getAllTrips()
    }
}
