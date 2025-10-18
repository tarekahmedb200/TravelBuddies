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
    @Published var feedMediaDataUIModels: [FeedMediaMetaDataUIModel] = []
    
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
                try await createFeedUseCase.execute(content: content, feedMediaMetaDataUIModels: feedMediaDataUIModels)
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
    
    func addImage(itemID:UUID,imageData:Data) {
        let feedMediaDataUIModel = FeedMediaMetaDataUIModel(id:itemID,mediaType: .image,feedImageData: imageData)
        
        feedMediaDataUIModels.append(feedMediaDataUIModel)
    }
    
    func removeImage(feedMediaDataUIModel:FeedMediaMetaDataUIModel) {
        feedMediaDataUIModels.removeAll { $0.id == feedMediaDataUIModel.id }
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
