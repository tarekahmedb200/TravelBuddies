//
//  AdminTripDetailsViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 03/10/2025.
//



import Foundation
import Combine

@MainActor
class AdminTripDetailsViewModel : ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var profileUIModels =  [ProfileUIModel]()
    
    var tripUIModel: TripUIModel
    
    private var currentProfileUIModel: ProfileUIModel?
    private let getCurrentProfileUseCase : GetCurrentProfileUseCase
    private let getCurrentProfileImageUseCase : GetCurrentProfileImageUseCase
    private let getProfilesUseCase : GetProfilesUseCase
    private let getProfileImageUseCase : GetProfileImageUseCase
    private let deleteTripUseCase : DeleteTripUseCase
    private let coordinator: any TripCoordinating
    
    init(tripUIModel: TripUIModel,getCurrentProfileUseCase: GetCurrentProfileUseCase, getProfilesUseCase: GetProfilesUseCase, getProfileImageUseCase : GetProfileImageUseCase,getCurrentProfileImageUseCase : GetCurrentProfileImageUseCase,deleteTripUseCase : DeleteTripUseCase, coordinator: any TripCoordinating) {
        self.tripUIModel = tripUIModel
        self.getCurrentProfileUseCase = getCurrentProfileUseCase
        self.getProfilesUseCase = getProfilesUseCase
        self.getProfileImageUseCase = getProfileImageUseCase
        self.getCurrentProfileImageUseCase = getCurrentProfileImageUseCase
        self.deleteTripUseCase = deleteTripUseCase
        
        self.coordinator = coordinator
    }
    
    
    func enterTripGroupChat() {
        coordinator.push(to: .tripGroupChat(tripUIModel: tripUIModel, isAdmin: true))
    }
    
    func getCurrentProfile() {
        Task {
            do {
                // Run these two in parallel
                async let profile = getCurrentProfileUseCase.execute()
                async let imageData = getCurrentProfileImageUseCase.execute()

                let (fetchedProfile, fetchedImageData) = try await (profile, imageData)

                currentProfileUIModel = fetchedProfile?.toUIModel()
                currentProfileUIModel?.profileImageData = fetchedImageData
                
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func getProfiles() {
        Task {
            do {
                let profiles = try await getProfilesUseCase.execute(profileIDs: tripUIModel.profileIDS)
                
                // Convert to UI models
                var uiModels = profiles.map { $0.toUIModel() }
                
                // Fetch images concurrently
                try await withThrowingTaskGroup(of: (UUID, Data?).self) { group in
                    for profile in uiModels {
                        group.addTask { [weak self] in
                            let imageData = try await self?.getProfileImageUseCase.execute(profileID: profile.id)
                            return (profile.id, imageData)
                        }
                    }
                    
                    // Update models with images as they arrive
                    for try await (id, imageData) in group {
                        if let index = uiModels.firstIndex(where: { $0.id == id }) {
                            uiModels[index].profileImageData = imageData
                        }
                    }
                }

                // Assign to state
                profileUIModels = uiModels
                
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    
    func deleteTrip() {
        Task {
            do {
                try await deleteTripUseCase.execute(tripID: tripUIModel.id)
                coordinator.popToRoot()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func popToRoot() {
        coordinator.popToRoot()
    }
    
}





