//
//  CreateTripUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation

protocol CreateTripUseCase {
    func execute(trip:Trip) async throws
}


class CreateTripUseCaseImplementation {
    private let tripRepository: TripRepository
    private let authenticationRepository: AuthenticationRepository
    
    init(tripRepository: TripRepository, authenticationRepository: AuthenticationRepository) {
        self.tripRepository = tripRepository
        self.authenticationRepository = authenticationRepository
    }
}

extension CreateTripUseCaseImplementation : CreateTripUseCase {
    func execute(trip:Trip) async throws {
        
        guard let adminID =  authenticationRepository.getCurrentUserID() else {
            return
        }
        
        return try await tripRepository.createTrip(trip: trip)
    }
}
