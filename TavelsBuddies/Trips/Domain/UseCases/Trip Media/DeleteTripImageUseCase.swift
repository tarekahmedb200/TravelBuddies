//
//  DeleteTripImageUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 04/10/2025.
//

import Foundation


protocol DeleteTripImageUseCase {
    func execute(tripID:UUID) async throws
}


class DeleteTripImageUseCaseImplementation {
    private var tripRepository : TripRepository
    
   init(tripRepository: TripRepository) {
        self.tripRepository = tripRepository
    }
}

extension DeleteTripImageUseCaseImplementation : DeleteTripImageUseCase {
    func execute(tripID:UUID) async throws {
        try await tripRepository.deleteTrip(tripID: tripID)
    }
}
