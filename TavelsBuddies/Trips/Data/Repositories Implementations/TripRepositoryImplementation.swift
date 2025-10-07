//
//  TripRepositoryImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation


class TripRepositoryImplementation  {
    
    private let tripService : TripService
    
    init(tripService: TripService) {
        self.tripService = tripService
    }
}


extension TripRepositoryImplementation : TripRepository {
    
    func getAllTrips() async throws -> [Trip] {
        try await tripService.getAllTrips().map {
            $0.toDomain()
        }
    }
    
    func searchTrips(tripFilter: TripFilter) async throws -> [Trip] {
        try await tripService.searchTrips(tripFilter: tripFilter).map {
            $0.toDomain()
        }
    }
    
    func getTrip(tripID:UUID) async throws -> Trip? {
        try await tripService.getTrip(tripID:tripID)?.toDomain()
    }
    
    func createTrip(trip: Trip) async throws {
        try await tripService.createTrip(tripDto: trip.toDto())
    }
    
    func getTripImageData(tripID: UUID) async throws -> Data? {
        try await tripService.getTripImageData(tripID: tripID)
    }
    
    
    func uploadTripImageData(tripID: UUID, imageData: Data) async throws {
        try await tripService.uploadTripImageData(tripID: tripID, imageData: imageData)
    }
    
    func updateTrip(trip: Trip) async throws {
        try await tripService.updateTrip(tripDto: trip.toDto())
    }
    
    func deleteTrip(tripID: UUID) async throws {
        try await tripService.deleteTrip(tripID: tripID)
    }
    
    func deleteTripImageData(tripID: UUID) async throws {
        try await tripService.deleteTripImageData(tripID: tripID)
    }
}
