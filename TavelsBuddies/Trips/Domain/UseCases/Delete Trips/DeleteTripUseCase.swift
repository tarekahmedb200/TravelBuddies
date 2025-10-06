//
//  DeleteTripUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 04/10/2025.
//

import Foundation

protocol DeleteTripUseCase {
    func execute(tripID:UUID) async throws
}


class DeleteTripUseCaseImplementation {
    private var tripRepository : TripRepository
    
   init(tripRepository: TripRepository) {
        self.tripRepository = tripRepository
    }
}

extension DeleteTripUseCaseImplementation : DeleteTripUseCase {
    func execute(tripID:UUID) async throws {
        try await tripRepository.deleteTrip(tripID: tripID)
    }
}
