//
//  CreateFeedViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import Foundation
import Combine

@MainActor
class CreateFeedViewModel : ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var content: String = ""
    @Published var errorMessage: String? = nil
    @Published var profileUIModel: ProfileUIModel?
    
    private let createFeedUseCase: CreateFeedUseCase
    private let getCurrentProfileUseCase : GetCurrentProfileUseCase
    private let coordinator: any FeedCoordinating
    
    init(createFeedUseCase: CreateFeedUseCase,getCurrentProfileUseCase : GetCurrentProfileUseCase,coordinator: any FeedCoordinating) {
        self.createFeedUseCase = createFeedUseCase
        self.getCurrentProfileUseCase = getCurrentProfileUseCase
        self.coordinator = coordinator
    }
    
    func createFeed() {
        Task {
            do {
                try await createFeedUseCase.execute(content: content)
                coordinator.dismissFullScreenCover()
            } catch {
                print(error)
                self.errorMessage = error.localizedDescription
            }
        }
    }
  
    func dismiss() {
        coordinator.dismissFullScreenCover()
    }
    
    func getCurrentProfile()  {
        
        Task {
            
            do {
                let currentProfile = try await getCurrentProfileUseCase.execute()
                profileUIModel  = currentProfile?.toUIModel()
            } catch  {
                errorMessage = error.localizedDescription
            }
        }
        
    }
}
