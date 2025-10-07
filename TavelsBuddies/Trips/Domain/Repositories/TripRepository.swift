//
//  TripRepository.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation


protocol TripRepository {
    func getAllTrips() async throws -> [Trip]
    func getTrip(tripID:UUID) async throws -> Trip?
    func searchTrips(tripFilter : TripFilter) async throws -> [Trip]
    
    func createTrip(trip: Trip) async throws
    func updateTrip(trip: Trip) async throws
    func deleteTrip(tripID: UUID) async throws
    
    func getTripImageData(tripID: UUID) async throws -> Data?
    func uploadTripImageData(tripID: UUID,imageData: Data) async throws
    func deleteTripImageData(tripID: UUID) async throws
}
