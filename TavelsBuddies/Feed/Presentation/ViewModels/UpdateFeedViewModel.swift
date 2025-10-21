//
//  UpdateFeedViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 20/10/2025.
//

import Foundation
import Combine

@MainActor
class UpdateFeedViewModel : ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var content: String = ""
    @Published var errorMessage: String? = nil
    @Published var profileUIModel: ProfileUIModel?
    @Published var feedUIModel: FeedUIModel
    
    @Published var oldFeedMediaDataUIModels: [FeedMediaMetaDataUIModel] = []
    @Published var newFeedMediaDataUIModels: [FeedMediaMetaDataUIModel] = []
    
    private let updateFeedUseCase: UpdateFeedUseCase
    private let getCurrentProfileUseCase : GetCurrentProfileUseCase
    private let coordinator: any FeedCoordinating
    
    init(feedUIModel: FeedUIModel,updateFeedUseCase: UpdateFeedUseCase, getCurrentProfileUseCase: GetCurrentProfileUseCase, coordinator: any FeedCoordinating) {
        self.feedUIModel = feedUIModel
        self.updateFeedUseCase = updateFeedUseCase
        self.getCurrentProfileUseCase = getCurrentProfileUseCase
        self.coordinator = coordinator
        
        loadFeedOldData()
    }
    
    func loadFeedOldData() {
        oldFeedMediaDataUIModels = feedUIModel.feedMediaMetaDataUIModels
        newFeedMediaDataUIModels = feedUIModel.feedMediaMetaDataUIModels
        content = feedUIModel.content
    }
    
    func updateFeed() {
        Task {
            do {
                try await updateFeedUseCase.execute(feedId: feedUIModel.id, content: content, oldFeedMediaMetaDataUIModels: oldFeedMediaDataUIModels, newFeedMediaMetaDataUIModels: newFeedMediaDataUIModels)
                dismiss()
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
        
        newFeedMediaDataUIModels.append(feedMediaDataUIModel)
    }
    
    func removeImage(feedMediaDataUIModel:FeedMediaMetaDataUIModel) {
        newFeedMediaDataUIModels.removeAll { $0.id == feedMediaDataUIModel.id }
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
