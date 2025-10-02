//
//  UploadTripImageUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation

protocol UploadTripImageUseCase {
    func execute(tripID:UUID,imageData:Data) async throws
}

class UploadTripImageUseCaseImplementation {
    private let tripRepository: TripRepository
    
    init(tripRepository: TripRepository) {
        self.tripRepository = tripRepository
    }
}

extension UploadTripImageUseCaseImplementation : UploadTripImageUseCase {
    func execute(tripID:UUID,imageData:Data) async throws  {
        return try await tripRepository.uploadTripImageData(tripID: tripID, imageData: imageData)
    }
}
