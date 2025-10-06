//
//  GetTripUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 05/10/2025.
//

import Foundation


protocol GetTripUseCase {
    func execute(tripID:UUID) async throws -> Trip
}

class GetTripUseCaseImplementation {
    private let tripRepository: TripRepository
    
    init(tripRepository: TripRepository) {
        self.tripRepository = tripRepository
    }
}

extension GetTripUseCaseImplementation : GetTripUseCase {
    func execute(tripID:UUID) async throws -> Trip {
        return try await tripRepository.getTrip(tripID:tripID)
    }
}
