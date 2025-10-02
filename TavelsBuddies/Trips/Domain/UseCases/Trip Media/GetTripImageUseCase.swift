//
//  GetTripImageUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation


protocol GetTripImageUseCase {
    func execute(tripID:UUID) async throws -> Data?
}

class GetTripImageUseCaseImplementation {
    private let tripRepository: TripRepository
    
    init(tripRepository: TripRepository) {
        self.tripRepository = tripRepository
    }
}

extension GetTripImageUseCaseImplementation : GetTripImageUseCase {
    func execute(tripID:UUID) async throws -> Data? {
        return try await tripRepository.getTripImageData(tripID: tripID)
    }
}
