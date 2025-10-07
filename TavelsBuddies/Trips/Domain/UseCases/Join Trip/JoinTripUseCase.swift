//
//  JoinTripUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 05/10/2025.
//

import Foundation

protocol JoinTripUseCase {
    func execute(tripID: UUID) async throws
}

class JoinTripUseCaseImplementation {
    private let updateTripUseCase: UpdateTripUseCase
    private let getCurrentProfileUseCase: GetCurrentProfileUseCase
    private let getTripUseCase: GetTripUseCase
    
    init(updateTripUseCase: UpdateTripUseCase, getCurrentProfileUseCase: GetCurrentProfileUseCase, getTripUseCase: GetTripUseCase) {
        self.updateTripUseCase = updateTripUseCase
        self.getCurrentProfileUseCase = getCurrentProfileUseCase
        self.getTripUseCase = getTripUseCase
    }
}


extension JoinTripUseCaseImplementation : JoinTripUseCase {
    func execute(tripID: UUID) async throws  {
        
        guard let currentProfileID = try await getCurrentProfileUseCase.execute()?.id,
              var updatedTrip = try await getTripUseCase.execute(tripID: tripID) else {
            return
        }
        
        updatedTrip.profilesIds.append(currentProfileID)
        try await updateTripUseCase.execute(trip: updatedTrip)
    }
}


