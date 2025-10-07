//
//  TripDetailsViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 03/10/2025.
//

import Foundation
import Combine

@MainActor
class MemberTripDetailsViewModel : ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var profileUIModels =  [ProfileUIModel]()
    @Published var tripUIModel: TripUIModel
    
    private var currentProfileUIModel: ProfileUIModel?
    private let getCurrentProfileUseCase : GetCurrentProfileUseCase
    private let getCurrentProfileImageUseCase : GetCurrentProfileImageUseCase
    private let getProfilesUseCase : GetProfilesUseCase
    private let getProfileImageUseCase : GetProfileImageUseCase
    private let joinTripUseCase : JoinTripUseCase
    private let leaveTripUseCase : LeaveTripUseCase
    private let coordinator: any TripCoordinating
    
    init(tripUIModel: TripUIModel,getCurrentProfileUseCase: GetCurrentProfileUseCase, getProfilesUseCase: GetProfilesUseCase, joinTripUseCase: JoinTripUseCase, leaveTripUseCase: LeaveTripUseCase,getProfileImageUseCase : GetProfileImageUseCase,getCurrentProfileImageUseCase : GetCurrentProfileImageUseCase, coordinator: any TripCoordinating) {
        self.tripUIModel = tripUIModel
        self.getCurrentProfileUseCase = getCurrentProfileUseCase
        self.getProfilesUseCase = getProfilesUseCase
        self.joinTripUseCase = joinTripUseCase
        self.leaveTripUseCase = leaveTripUseCase
        self.getProfileImageUseCase = getProfileImageUseCase
        self.getCurrentProfileImageUseCase = getCurrentProfileImageUseCase
        self.coordinator = coordinator
        
    }
    
    func enterTripGroupChat() {
        coordinator.push(to: .tripGroupChat(tripUIModel: tripUIModel, isAdmin: false))
    }
    
    func handleJoiningTrip() {
        
        guard let currentProfileUIModel = currentProfileUIModel else {
            return
        }

        Task {
            do {
                isLoading = true
                
                if checkIfJoined() {
                    try await leaveTripUseCase.execute(tripID: tripUIModel.id)
                    profileUIModels.removeAll(where: { $0.id == currentProfileUIModel.id })
                }else {
                    try await joinTripUseCase.execute(tripID: tripUIModel.id)
                    profileUIModels.append(currentProfileUIModel)
                }
                
                isLoading = false
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func checkIfJoined() -> Bool {
        guard let currentProfileID = currentProfileUIModel?.id else {
            return false
        }
        
        return profileUIModels.contains(where: { $0.id == currentProfileID })
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

    
    
}





