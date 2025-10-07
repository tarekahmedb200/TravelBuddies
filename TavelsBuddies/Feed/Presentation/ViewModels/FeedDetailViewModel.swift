//
//  FeedDetailViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation
import Combine

@MainActor
class FeedDetailViewModel : ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var feedCommentUIModels = [FeedCommentUIModel]()
    @Published var feedComment: String = ""
    @Published var errorMessage: String? = nil
    @Published var feedUIModel: FeedUIModel
    @Published var currentProfileUIModel: ProfileUIModel?
    
    private let createFeedCommentUseCase: CreateFeedCommentUseCase
    private let getAllFeedCommentsUseCase : GetAllFeedCommentsUseCase
    
    private let getProfilesUseCase: GetProfilesUseCase
    private let getCurrentProfileUseCase: GetCurrentProfileUseCase
    
    private let getCurrentProfileImageUseCase: GetCurrentProfileImageUseCase
    private let getProfileImageUseCase: GetProfileImageUseCase
    
    private let likeFeedUseCase: LikeFeedUseCase
    private let unlikeFeedUseCase: UnLikeFeedUseCase
    
    
    private let observeNewlyInsertedFeedCommentsUseCase: ObserveNewlyInsertedFeedCommentsUseCase
    
    

    private let coordinator: any FeedCoordinating
    
    private var profileUIModelCache: [UUID: ProfileUIModel] = [:]
    private var profilesImagesCache: [UUID: Data] = [:]
    
    init(feedUIModel: FeedUIModel, createFeedCommentUseCase: CreateFeedCommentUseCase, getAllFeedCommentsUseCase: GetAllFeedCommentsUseCase, getProfilesUseCase: GetProfilesUseCase, likeFeedUseCase: LikeFeedUseCase,getCurrentProfileUseCase : GetCurrentProfileUseCase, unlikeFeedUseCase: UnLikeFeedUseCase,
         getCurrentProfileImageUseCase: GetCurrentProfileImageUseCase,getProfileImageUseCase: GetProfileImageUseCase,observeNewlyInsertedFeedCommentsUseCase: ObserveNewlyInsertedFeedCommentsUseCase, coordinator: any FeedCoordinating) {
        self.feedUIModel = feedUIModel
        self.createFeedCommentUseCase = createFeedCommentUseCase
        self.getAllFeedCommentsUseCase = getAllFeedCommentsUseCase
        self.getProfilesUseCase = getProfilesUseCase
        self.likeFeedUseCase = likeFeedUseCase
        self.unlikeFeedUseCase = unlikeFeedUseCase
        self.getCurrentProfileUseCase = getCurrentProfileUseCase
        self.getCurrentProfileImageUseCase = getCurrentProfileImageUseCase
        self.getProfileImageUseCase = getProfileImageUseCase
        self.observeNewlyInsertedFeedCommentsUseCase =  observeNewlyInsertedFeedCommentsUseCase
        
        self.coordinator = coordinator
    }
    
    func loadAllFeedComments() {
        Task {
            do {
                let sortedFeedComments = try await getAllFeedCommentsUseCase.execute(feedID: feedUIModel.id).sorted { $0.createdAt < $1.createdAt }
                
                feedCommentUIModels = sortedFeedComments.map { $0.toUIModel() }
                
                try await handleNewFeedComments(sortedFeedComments)
            } catch {
                print(error)
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func createFeedComment() {
        Task {
            do {
                try await createFeedCommentUseCase.execute(feedID:feedUIModel.id , content: feedComment)
                feedComment = ""
            } catch {
                print(error)
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func toggleLikeFeed(feedID: UUID)  {
        
        Task {
            do {
                
                if await checkIfFeedIsLiked(feedID: feedID) {
                    try await unlikeFeedUseCase.execute(feedID: feedID)
                    updateFeedUIModelLikeState(feedID: feedID, like: false)
                }else {
                    try await likeFeedUseCase.execute(feedID: feedID)
                    updateFeedUIModelLikeState(feedID: feedID, like: true)
                }
                
            } catch  {
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    func pop() {
        coordinator.popToRoot()
    }
    
    private func checkIfFeedIsLiked(feedID: UUID) async -> Bool {
        return feedUIModel.isLikedByCurrentProfile == true
    }
    
    private func updateFeedUIModelLikeState(feedID: UUID,like:Bool) {
        feedUIModel.isLikedByCurrentProfile = like
        feedUIModel.likesCount +=  like ? 1 : -1
    }
    
    private func handleNewFeedComments(_ comments: [FeedComment]) async throws {
        try await updateTheCache(comments)
        updateFeedCommentsUIModels(comments)
    }
    
    fileprivate func updateTheCache(_ comments: [FeedComment]) async throws {
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            
            group.addTask {
                try await self.fillProfileUIModelCache(comments)
            }
            
            group.addTask {
                try await self.fillProfilesImageCache(comments)
            }
            
            try await group.waitForAll()
        }
    }
    
    private func fillProfileUIModelCache(_ comments: [FeedComment]) async throws {
        
        let profilesIds = comments
            .map { $0.profileID }
            .filter { profileUIModelCache[$0] == nil }
        
        let newProfiles = try await getProfilesUseCase.execute(profileIDs: profilesIds)
        for profile in newProfiles {
            if let profileID = profile.id {
                profileUIModelCache[profileID] = profile.toUIModel()
            }
        }
    }
    
    private func fillProfilesImageCache(_ comments: [FeedComment]) async throws {
        // Collect only missing profile IDs
        let profileIds = comments
            .map { $0.profileID }
            .filter { profilesImagesCache[$0] == nil }

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
    
    private func updateFeedCommentsUIModels(_ sortedComments: [FeedComment]) {
       
        for comment in sortedComments {
            if var index = feedCommentUIModels.firstIndex(where: { $0.id == comment.id }) {
                feedCommentUIModels[index].profileUIModel = profileUIModelCache[comment.profileID]
                feedCommentUIModels[index].profileUIModel?.profileImageData = profilesImagesCache[comment.profileID]
            }
        }
        
    }
    
    func getCurrentProfile() {
        Task {
            do {
                currentProfileUIModel = try await getCurrentProfileUseCase.execute()?.toUIModel()
                currentProfileUIModel?.profileImageData = try await getCurrentProfileImageUseCase.execute()
            } catch  {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func observeNewlyInsertedFeedComments() {
        Task {
            for await feedComment in observeNewlyInsertedFeedCommentsUseCase.execute() {
                let uiModel = feedComment.toUIModel()
                feedCommentUIModels.insert(uiModel, at: 0)
                try await handleNewFeedComments([feedComment])
            }
        }
    }
    
}




