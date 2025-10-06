//
//  UpdateTripUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 04/10/2025.
//

import Foundation

protocol UpdateTripUseCase {
    func execute(trip:Trip) async throws
}


class UpdateTripUseCaseImplementation {
    private var tripRepository : TripRepository
    
   init(tripRepository: TripRepository) {
        self.tripRepository = tripRepository
    }
}

extension UpdateTripUseCaseImplementation : UpdateTripUseCase {
    func execute(trip:Trip) async throws {
        try await tripRepository.updateTrip(trip: trip)
    }
}
