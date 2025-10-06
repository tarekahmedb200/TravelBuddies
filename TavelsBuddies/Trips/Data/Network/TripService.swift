//
//  TripService.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation


protocol TripService {
    func getAllTrips() async throws -> [TripDto]
    func searchTrips(tripFilter : TripFilter) async throws -> [TripDto]
    func getTrip(tripID:UUID) async throws -> TripDto
    
    func createTrip(tripDto: TripDto) async throws
    func updateTrip(tripDto: TripDto) async throws
    func deleteTrip(tripID: UUID) async throws
    
    func getTripImageData(tripID: UUID) async throws -> Data?
    func uploadTripImageData(tripID: UUID,imageData: Data) async throws
    func deleteTripImageData(tripID: UUID) async throws
}
