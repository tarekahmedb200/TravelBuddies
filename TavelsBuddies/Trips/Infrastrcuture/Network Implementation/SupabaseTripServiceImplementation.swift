//
//  SupabaseTripServiceImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation


class SupabaseTripServiceImplementation {
    private let databaseCreate: DatabaseCreateService
    private let databaseGet: DatabaseGetService
    private let databaseUpdate: DatabaseUpdateService
    private let databaseDelete: DatabaseDeleteService
    private let supabaseMediaManager: SupabaseMediaManager
    
    private let tripTableName = SupabaseTableNames.trip.rawValue
    private let tripImageStorageName = SupabaseStorageNames.tripImage.rawValue
    
    init() {
        databaseCreate = DatabaseCreateService()
        databaseGet = DatabaseGetService()
        databaseUpdate = DatabaseUpdateService()
        databaseDelete = DatabaseDeleteService()
        supabaseMediaManager = SupabaseMediaManager()
    }
}

extension SupabaseTripServiceImplementation: TripService {
    
    
    func getAllTrips() async throws -> [TripDto] {
        try await databaseGet.getArray(tableName: tripTableName)
    }
    
    func getTrip(tripID:UUID) async throws -> TripDto {
        try await databaseGet.getSingle(tableName: tripTableName, id: tripID)
    }
    
    func searchTrips(tripFilter: TripFilter) async throws -> [TripDto] {
        guard let client = SupabaseManager().getClient() else {
            throw SupabaseDatabaseError.clientNotAvailable
        }
        
        var query = SupabaseQueryBuilder(client: client, tableName: "trips")
        
        if let location = tripFilter.location {
            query = query.byEqual(TripDto.CodingKeys.location.stringValue, value: location)
        }
        
        if let dateRange = tripFilter.dateRange {
            query = query.byRange(TripDto.CodingKeys.occurrenceDate.stringValue, range: dateRange)
        }
        
        if let tags = tripFilter.tags {
            query = query.byArrayContains(TripDto.CodingKeys.tags.stringValue, values: tags)
        }
        
        if let isFree = tripFilter.isFree {
            query = query.byBool(TripDto.CodingKeys.isFree.stringValue, value: isFree)
        }
        
        if let priceRange = tripFilter.priceRange {
            query = query.byRange(TripDto.CodingKeys.price.stringValue, range: priceRange)
        }
        
        let trips: [TripDto] = try await query
            .orderBy(TripDto.CodingKeys.occurrenceDate.stringValue, ascending: true)
            .execute()
        
        return trips
    }
    
    func createTrip(tripDto: TripDto)  async throws {
        try await databaseCreate.create(tripDto, tableName: tripTableName)
    }
    
    func getTripImageData(tripID: UUID) async throws -> Data? {
        try await  supabaseMediaManager.getImage(storageName: tripImageStorageName, id: tripID)
    }
    
    func uploadTripImageData(tripID: UUID,imageData: Data) async throws {
        try await supabaseMediaManager.uploadImage(storageName: tripImageStorageName, id: tripID, imageData: imageData)
    }
    
    func updateTrip(tripDto: TripDto) async throws {
        try await databaseUpdate.update(tableName: tripTableName, with: tripDto,
                                        conditions: [TripDto.CodingKeys.id.rawValue : tripDto.id])
    }
    
    func deleteTrip(tripID: UUID) async throws {
        try await databaseDelete.delete(tableName: tripTableName,conditions:
                                            [TripDto.CodingKeys.id.rawValue : tripID]
        )
    }
    
    func deleteTripImageData(tripID: UUID) async throws {
        try await supabaseMediaManager.deleteImage(storageName: tripImageStorageName, id: tripID)
    }
    
}
