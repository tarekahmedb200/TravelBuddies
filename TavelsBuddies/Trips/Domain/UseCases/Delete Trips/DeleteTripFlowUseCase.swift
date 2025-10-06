//
//  DeleteTripFlowUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 04/10/2025.
//

import Foundation


protocol DeleteTripFlowUseCase {
    func execute(tripID:UUID) async throws
}


class DeleteTripFlowUseCaseImplementation {
    private var deleteTripUseCase: DeleteTripUseCase
    private var deleteTripImageUseCase: DeleteTripImageUseCase
    
    init(deleteTripUseCase: DeleteTripUseCase, deleteTripImageUseCase: DeleteTripImageUseCase) {
        self.deleteTripUseCase = deleteTripUseCase
        self.deleteTripImageUseCase = deleteTripImageUseCase
    }
}

extension DeleteTripFlowUseCaseImplementation : DeleteTripFlowUseCase {
    func execute(tripID: UUID) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            // Delete trip image
            group.addTask {
                try await self.deleteTripImageUseCase.execute(tripID: tripID)
            }
            
            // Delete trip
            group.addTask {
                try await self.deleteTripUseCase.execute(tripID: tripID)
            }
            
            // Wait for both to complete
            try await group.waitForAll()
        }
    }
}
