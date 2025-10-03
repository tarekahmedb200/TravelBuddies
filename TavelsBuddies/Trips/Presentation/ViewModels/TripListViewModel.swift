//
//  TripListViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation
import Combine

@MainActor
class TripListViewModel: ObservableObject {
    
    @Published var tripUIModels = [TripUIModel]()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let getAllTripsUseCase: GetAllTripsUseCase
    private let searchTripsUseCase: SearchTripsUseCase
    private let getProfilesUseCase: GetProfilesUseCase
    private let getProfileImageUseCase: GetProfileImageUseCase
    private let getTripImageUseCase: GetTripImageUseCase
    
    private let coordinator: any TripCoordinating
    
    // caches
    private var profileUIModelCache: [UUID: ProfileUIModel] = [:]
    private var profilesImagesCache: [UUID: Data] = [:]
    private var tripsImagesCache: [UUID: Data] = [:]
    
    
    init(
        getAllTripsUseCase: GetAllTripsUseCase,
        searchTripsUseCase: SearchTripsUseCase,
        getProfilesUseCase: GetProfilesUseCase,
        getProfileImageUseCase: GetProfileImageUseCase,
        getTripImageUseCase: GetTripImageUseCase,
        coordinator: any TripCoordinating
    ) {
        self.getAllTripsUseCase = getAllTripsUseCase
        self.searchTripsUseCase = searchTripsUseCase
        self.getProfilesUseCase = getProfilesUseCase
        self.getProfileImageUseCase = getProfileImageUseCase
        self.getTripImageUseCase = getTripImageUseCase
        self.coordinator = coordinator
    }
    
    
    func loadTrips() {
        Task {
            do {
                isLoading = true
                let sortedTrips = try await getAllTripsUseCase.execute().sorted { $0.createdAt > $1.createdAt }
                tripUIModels = sortedTrips.map { $0.toUIModel() }
                
                try await handleNewTrips(sortedTrips)
            } catch {
                print(error)
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    
    func navigateToTripDetails(tripUIModel:TripUIModel) {
        coordinator.push(to: .tripDetails(trip: tripUIModel))
    }
    
    func showCreateFeed() {
        coordinator.presentFullScreenCover(.createTrip)
    }
    
    private func handleNewTrips(_ trips: [Trip]) async throws {
        try await updateTheCache(trips)
        updateTripUIModels(trips)
    }
    
    private func updateTheCache(_ trips: [Trip]) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                try await self.fillProfileUIModelCache(trips: trips)
            }
            group.addTask {
                try await self.fillProfilesImageCache(trips: trips)
            }
            group.addTask {
                try await self.fillTripsImageCache(trips: trips)
            }
            
            try await group.waitForAll()
        }
    }
    
    
    private func fillProfileUIModelCache(trips: [Trip]) async throws {
        let profileIds = Array(
            Set(
                trips.map { $0.adminId }
            )
        )
        
        guard !profileIds.isEmpty else { return }
        
        let newProfiles = try await getProfilesUseCase.execute(profileIDs: profileIds)
        for profile in newProfiles {
            if let profileID = profile.id {
                profileUIModelCache[profileID] = profile.toUIModel()
            }
        }
    }
    
    
    private func fillProfilesImageCache(trips: [Trip]) async throws {
        
        let profileIds = Array(
            Set(
                trips.map { $0.adminId }
            )
        )
        
        guard !profileIds.isEmpty else { return }
        
        try await withThrowingTaskGroup(of: (UUID, Data?).self) { group in
            for id in profileIds {
                group.addTask {
                    let data = try? await self.getProfileImageUseCase.execute(profileID: id)
                    return (id, data)
                }
            }
            
            for try await (id, data) in group {
                if let data {
                    profilesImagesCache[id] = data
                }
            }
        }
    }
    
    
    private func fillTripsImageCache(trips: [Trip]) async throws {
        let tripIds = trips
            .map { $0.id }
            
        guard !tripIds.isEmpty else { return }
        
        try await withThrowingTaskGroup(of: (UUID, Data?).self) { group in
            for id in tripIds {
                group.addTask {
                    let data = try? await self.getTripImageUseCase.execute(tripID: id)
                    return (id, data)
                }
            }
            
            for try await (id, data) in group {
                if let data {
                    tripsImagesCache[id] = data
                }
            }
        }
    }
    
    
    private func updateTripUIModels(_ sortedTrips: [Trip]) {
        for trip in sortedTrips {
            if let index = tripUIModels.firstIndex(where: { $0.id == trip.id }) {
                
                // Attach profile info + profile image
                tripUIModels[index].adminUIModel = profileUIModelCache[trip.adminId]
                tripUIModels[index].adminUIModel?.profileImageData = profilesImagesCache[trip.adminId]
                
                // Attach trip image if exists
                tripUIModels[index].tripImageData = tripsImagesCache[trip.id]
            }
        }
    }
}
