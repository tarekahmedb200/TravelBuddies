//
//  CreateTripFlowUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 03/10/2025.
//

import Foundation

protocol CreateTripFlowUseCase {
    func execute(title: String,description: String,location: String,occurrenceDate: Date, isFree: Bool, maxParticipants: Int, tags: [TripTag], price: Double, imageData: Data) async throws
}


class CreateTripFlowUseCaseImplementation {
    private let createTripUseCase: CreateTripUseCase
    private let uploadTripImageUseCase: UploadTripImageUseCase
    private let authenticationRepository: AuthenticationRepository
    
    init(createTripUseCase: CreateTripUseCase, uploadTripImageUseCase: UploadTripImageUseCase,authenticationRepository: AuthenticationRepository) {
        self.createTripUseCase = createTripUseCase
        self.uploadTripImageUseCase = uploadTripImageUseCase
        self.authenticationRepository = authenticationRepository
    }
}

extension CreateTripFlowUseCaseImplementation : CreateTripFlowUseCase {
    func execute(title: String,description: String,location: String,occurrenceDate: Date, isFree: Bool, maxParticipants: Int, tags: [TripTag], price: Double, imageData: Data) async throws {
        
        guard let adminID =  authenticationRepository.getCurrentUserID() else {
            return
        }
        
        let tripToCreate = Trip(id: UUID(), title: title, description: description, location: location, occurrenceDate: occurrenceDate, createdAt: Date(), isFree: isFree, maxParticipants: maxParticipants, tags: tags, price: price, adminId: adminID, profilesIds: [])
        
        try await createTripUseCase.execute(trip: tripToCreate)
        
        
        guard let imageCompressedData = await ImageCompressor.resizeAndCompress(imageData) else {
            return
        }
        
        try await uploadTripImageUseCase.execute(tripID: tripToCreate.id, imageData: imageCompressedData)
    }
}
