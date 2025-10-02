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
    
    func createTrip(tripDto: TripDto) async throws
    func getTripImageData(tripID: UUID) async throws -> Data?
    func uploadTripImageData(tripID: UUID,imageData: Data) async throws
}
