//
//  FeedDetailViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation
import Combine

@MainActor
class FeedDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var feedCommentUIModels = [FeedCommentUIModel]()
    @Published var feedComment: String = ""
    @Published var errorMessage: String? = nil
    @Published var feedUIModel: FeedUIModel
    @Published var currentProfileUIModel: ProfileUIModel?
    
    // MARK: - Private Dependencies (Use Cases)
    private let createFeedCommentUseCase: CreateFeedCommentUseCase
    private let getAllFeedCommentsUseCase: GetAllFeedCommentsUseCase
    private let getProfilesUseCase: GetProfilesUseCase
    private let getCurrentProfileUseCase: GetCurrentProfileUseCase
    private let getCurrentProfileImageUseCase: GetCurrentProfileImageUseCase
    private let getProfileImageUseCase: GetProfileImageUseCase
    private let likeFeedUseCase: LikeFeedUseCase
    private let unlikeFeedUseCase: UnLikeFeedUseCase
    private let observeNewlyInsertedFeedCommentsUseCase: ObserveNewlyInsertedFeedCommentsUseCase
    
    // Newly injected for refetching feed + media + likes
    private let getSingleFeedUseCase: GetSingleFeedUseCase
    private let getFeedMediaDatasUseCase: GetFeedMediaDatasUseCase
    private let getActualFeedMediaUseCase: GetActualFeedMediaUseCase
    private let getAllFeedsLikesUseCase: GetAllFeedsLikesUseCase
    
    // Delete feed
    private let deleteFeedUseCase: DeleteFeedUseCase
    
    // MARK: - Coordinator
    private let coordinator: any FeedCoordinating
    
    // MARK: - Caches
    private var profileUIModelCache: [UUID: ProfileUIModel] = [:]
    private var profilesImagesCache: [UUID: Data] = [:]
    
    // MARK: - Init
    init(
        feedUIModel: FeedUIModel,
        createFeedCommentUseCase: CreateFeedCommentUseCase,
        getAllFeedCommentsUseCase: GetAllFeedCommentsUseCase,
        getProfilesUseCase: GetProfilesUseCase,
        likeFeedUseCase: LikeFeedUseCase,
        getCurrentProfileUseCase: GetCurrentProfileUseCase,
        unlikeFeedUseCase: UnLikeFeedUseCase,
        getCurrentProfileImageUseCase: GetCurrentProfileImageUseCase,
        getProfileImageUseCase: GetProfileImageUseCase,
        observeNewlyInsertedFeedCommentsUseCase: ObserveNewlyInsertedFeedCommentsUseCase,
        // New dependencies
        getSingleFeedUseCase: GetSingleFeedUseCase,
        getFeedMediaDatasUseCase: GetFeedMediaDatasUseCase,
        getActualFeedMediaUseCase: GetActualFeedMediaUseCase,
        getAllFeedsLikesUseCase: GetAllFeedsLikesUseCase,
        // Delete dependency
        deleteFeedUseCase: DeleteFeedUseCase,
        coordinator: any FeedCoordinating
    ) {
        self.feedUIModel = feedUIModel
        self.createFeedCommentUseCase = createFeedCommentUseCase
        self.getAllFeedCommentsUseCase = getAllFeedCommentsUseCase
        self.getProfilesUseCase = getProfilesUseCase
        self.likeFeedUseCase = likeFeedUseCase
        self.unlikeFeedUseCase = unlikeFeedUseCase
        self.getCurrentProfileUseCase = getCurrentProfileUseCase
        self.getCurrentProfileImageUseCase = getCurrentProfileImageUseCase
        self.getProfileImageUseCase = getProfileImageUseCase
        self.observeNewlyInsertedFeedCommentsUseCase = observeNewlyInsertedFeedCommentsUseCase
        self.getSingleFeedUseCase = getSingleFeedUseCase
        self.getFeedMediaDatasUseCase = getFeedMediaDatasUseCase
        self.getActualFeedMediaUseCase = getActualFeedMediaUseCase
        self.getAllFeedsLikesUseCase = getAllFeedsLikesUseCase
        self.deleteFeedUseCase = deleteFeedUseCase
        self.coordinator = coordinator
    }
}

// MARK: - Public API
extension FeedDetailViewModel {
    
    func loadAllFeedComments() {
        Task {
            do {
                let sortedFeedComments = try await getAllFeedCommentsUseCase
                    .execute(feedID: feedUIModel.id)
                    .sorted { $0.createdAt < $1.createdAt }
                
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
                try await createFeedCommentUseCase.execute(feedID: feedUIModel.id, content: feedComment)
                feedComment = ""
            } catch {
                print(error)
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func toggleLikeFeed(feedID: UUID) {
        Task {
            do {
                if await checkIfFeedIsLiked(feedID: feedID) {
                    try await unlikeFeedUseCase.execute(feedID: feedID)
                    updateFeedUIModelLikeState(feedID: feedID, like: false)
                } else {
                    try await likeFeedUseCase.execute(feedID: feedID)
                    updateFeedUIModelLikeState(feedID: feedID, like: true)
                }
            } catch {
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    func pop() {
        coordinator.popToRoot()
    }
    
    // Refetch the feed, map to UI model, and update likes and photos
    func refetchFeed() {
        Task {
            do {
                isLoading = true
                // 1) Fetch latest feed
                guard let latestFeed = try await getSingleFeedUseCase.execute(feedId: feedUIModel.id) else {
                    isLoading = false
                    return
                }
                
                // 2) Map to UI model (basic fields)
                var updatedUIModel = latestFeed.toUImodel()
                
                // 3) Reuse existing profile from old object (no network/profile fetch)
                updatedUIModel.profileUIModel = self.feedUIModel.profileUIModel
                
                // 4) Refresh media metadata + actual images
                try await updateMediaForRefetchedFeed(feed: latestFeed, uiModel: &updatedUIModel)
                
                // 5) Refresh likes (count + current user liked)
                try await updateLikesForRefetchedFeed(feed: latestFeed, uiModel: &updatedUIModel)
                
                // 6) Assign back to published property
                self.feedUIModel = updatedUIModel
                isLoading = false
            } catch {
                isLoading = false
                print(error)
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func getCurrentProfile() {
        Task {
            do {
                currentProfileUIModel = try await getCurrentProfileUseCase.execute()?.toUIModel()
                currentProfileUIModel?.profileImageData = try await getCurrentProfileImageUseCase.execute()
            } catch {
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

// MARK: - Navigation
extension FeedDetailViewModel {
    func showUpdateFeed() {
        coordinator.presentFullScreenCover(.updateFeed(feed: feedUIModel, onDismiss: { [weak self] in
            self?.refetchFeed()
        }))
    }
}

// MARK: - Private Helpers (Likes/State)
extension FeedDetailViewModel {
    
    private func checkIfFeedIsLiked(feedID: UUID) async -> Bool {
        return feedUIModel.isLikedByCurrentProfile == true
    }
    
    private func updateFeedUIModelLikeState(feedID: UUID, like: Bool) {
        feedUIModel.isLikedByCurrentProfile = like
        feedUIModel.likesCount += like ? 1 : -1
    }
}

// MARK: - Private Helpers (Comments processing & cache)
extension FeedDetailViewModel {
    
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
            if let index = feedCommentUIModels.firstIndex(where: { $0.id == comment.id }) {
                feedCommentUIModels[index].profileUIModel = profileUIModelCache[comment.profileID]
                feedCommentUIModels[index].profileUIModel?.profileImageData = profilesImagesCache[comment.profileID]
            }
        }
    }
}

// MARK: - Private Helpers (Refetch building blocks)
extension FeedDetailViewModel {
    
    private func updateMediaForRefetchedFeed(feed: Feed, uiModel: inout FeedUIModel) async throws {
        var mediaUIModels = try await getFeedMediaDatasUseCase.execute(feedIds: [feed.id]).map { $0.toUIModel() }
        
        try await withThrowingTaskGroup(of: (Data?, UUID?).self) { group in
            for meta in mediaUIModels {
                group.addTask {
                    (try? await self.getActualFeedMediaUseCase.execute(feedMediaDataID: meta.id), meta.id)
                }
            }
            for try await (data, id) in group {
                if let data, let id, let idx = mediaUIModels.firstIndex(where: { $0.id == id }) {
                    mediaUIModels[idx].feedImageData = data
                }
            }
        }
        
        // Filter to this feed and assign
        uiModel.feedMediaMetaDataUIModels = mediaUIModels.filter { $0.feedId == feed.id }
    }
    
    private func updateLikesForRefetchedFeed(feed: Feed, uiModel: inout FeedUIModel) async throws {
        let likes = try await getAllFeedsLikesUseCase.execute(feedIDs: [feed.id])
        let likesForThisFeed = likes.filter { $0.feedID == feed.id }
        uiModel.likesCount = likesForThisFeed.count
        
        if let currentProfileID = currentProfileUIModel?.id {
            uiModel.isLikedByCurrentProfile = likesForThisFeed.contains { $0.profileID == currentProfileID }
        } else {
            uiModel.isLikedByCurrentProfile = false
        }
    }
}

// MARK: - Public API: Delete Feed
extension FeedDetailViewModel {
    func deleteFeed() {
        Task {
            do {
                isLoading = true
                
                try await deleteFeedUseCase.execute(feedID: feedUIModel.id, feedMetaDatas: feedUIModel.feedMediaMetaDataUIModels)
                
                isLoading = false
                coordinator.popToRoot()
            } catch {
                isLoading = false
                print(error)
                errorMessage = error.localizedDescription
            }
        }
    }
}
