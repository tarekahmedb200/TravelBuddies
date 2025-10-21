//
//  FeedListViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation
import Combine

@MainActor
class FeedListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var feedUIModels = [FeedUIModel]()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Private Properties (Use Cases)
    private let getAllFeedsUseCase: GetAllFeedsUseCase
    private let deleteFeedUseCase: DeleteFeedUseCase
    private let observeNewlyInsertedFeedsUseCase: ObserveFeedsChangesUseCase
    private let getAllFeedLikesUseCase: GetAllFeedsLikesUseCase
    private let likeFeedUseCase: LikeFeedUseCase
    private let unlikeFeedUseCase: UnLikeFeedUseCase
    private let getProfilesUseCase: GetProfilesUseCase
    private let getCurrentProfileUseCase: GetCurrentProfileUseCase
    private let getProfileImageUseCase: GetProfileImageUseCase
    
    private let getFeedMediaDatasUseCase : GetFeedMediaDatasUseCase
    private let getActualFeedMediaUseCase : GetActualFeedMediaUseCase
    private let deleteActualFeedMediaUseCase : DeleteActualFeedMediaUseCase
    
    private let coordinator: any FeedCoordinating
    
    // MARK: - Private Properties (Cache & State)
    private var currentProfile: Profile?
    private var profileUIModelCache: [UUID: ProfileUIModel] = [:]
    private var profilesImagesCache: [UUID: Data] = [:]
    private var feedMediaMetaDataUIModelsCache: [UUID: [FeedMediaMetaDataUIModel]] = [:]
    
    private var feedLikes = [FeedLike]()
    
    // MARK: - Initializer
    init(
        getAllFeedsUseCase: GetAllFeedsUseCase,
        getAllFeedLikesUseCase: GetAllFeedsLikesUseCase,
        likeFeedUseCase: LikeFeedUseCase,
        unlikeFeedUseCase: UnLikeFeedUseCase,
        getProfilesUseCase: GetProfilesUseCase,
        getCurrentProfileUseCase: GetCurrentProfileUseCase,
        getProfileImageUseCase: GetProfileImageUseCase,
        observeNewlyInsertedFeedsUseCase: ObserveFeedsChangesUseCase,
        getFeedMediaDatasUseCase : GetFeedMediaDatasUseCase,
        getActualFeedMediaUseCase : GetActualFeedMediaUseCase,
        deleteActualFeedMediaUseCase : DeleteActualFeedMediaUseCase,
        deleteFeedUseCase: DeleteFeedUseCase,
        coordinator: any FeedCoordinating
    ) {
        self.getAllFeedsUseCase = getAllFeedsUseCase
        self.getAllFeedLikesUseCase = getAllFeedLikesUseCase
        self.likeFeedUseCase = likeFeedUseCase
        self.unlikeFeedUseCase = unlikeFeedUseCase
        self.getProfilesUseCase = getProfilesUseCase
        self.getCurrentProfileUseCase = getCurrentProfileUseCase
        self.getProfileImageUseCase = getProfileImageUseCase
        self.observeNewlyInsertedFeedsUseCase = observeNewlyInsertedFeedsUseCase
        self.getFeedMediaDatasUseCase = getFeedMediaDatasUseCase
        self.getActualFeedMediaUseCase = getActualFeedMediaUseCase
        self.deleteActualFeedMediaUseCase = deleteActualFeedMediaUseCase
        self.deleteFeedUseCase = deleteFeedUseCase
        self.coordinator = coordinator
        
        
        observeNewlyInsertedFeeds()
    }
}

// MARK: - Navigation
extension FeedListViewModel {
    
    func enterProfileDetails(profileUIModel: ProfileUIModel) {
        coordinator.push(to: .profileDetails(profileUIModel: profileUIModel))
    }
    
    func navigateToFeedDetails(feedUIModel: FeedUIModel) {
        coordinator.push(to: .feedDetails(feed: feedUIModel))
    }
    
    func showCreateFeed() {
        coordinator.presentFullScreenCover(.createFeed)
    }
    
    func showUpdateFeed(feedUIModel: FeedUIModel) {
        coordinator.presentFullScreenCover(.updateFeed(feed: feedUIModel, onDismiss: {}))
    }
}

// MARK: - Profile Management
extension FeedListViewModel {
    
    func getCurrentProfile() {
        Task {
            do {
                currentProfile = try await getCurrentProfileUseCase.execute()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

// MARK: - Feed Loading
extension FeedListViewModel {
    
    func loadFeeds() {
        Task {
            do {
                isLoading = true
                
                let sortedFeeds = try await getAllFeedsUseCase.execute().sorted { $0.createdAt > $1.createdAt }
                feedUIModels = sortedFeeds.map { $0.toUImodel() }
                try await handleNewFeeds(sortedFeeds)
            } catch {
                print(error)
                print(error.localizedDescription)
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func observeNewlyInsertedFeeds() {
        Task {
            for await (feed,crudType) in observeNewlyInsertedFeedsUseCase.execute() {
                
                // Delay before processing each event
                try? await Task.sleep(for: .seconds(1))
                
                switch crudType {
                case .insert:
                    let uiModel = feed.toUImodel()
                    feedUIModels.insert(uiModel, at: 0)
                    try await handleNewFeeds([feed])
                case .update:
                    try await updateExistingFeeds([feed])
                case .delete:
                    try await deleteExistingFeeds([feed.id])
                }
            
            }
        }
    }
}

// MARK: - Like/Unlike Operations
extension FeedListViewModel {
    
    func toggleLikeFeed(feedID: UUID) {
        Task {
            do {
                if await checkIfFeedIsLiked(feedID: feedID) {
                    try await unlikeFeedUseCase.execute(feedID: feedID)
                    updateFeedLikeStateInFeedUIModels(feedID: feedID, like: false)
                } else {
                    try await likeFeedUseCase.execute(feedID: feedID)
                    updateFeedLikeStateInFeedUIModels(feedID: feedID, like: true)
                }
            } catch {
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    private func checkIfFeedIsLiked(feedID: UUID) async -> Bool {
        return feedUIModels.first(where: { $0.id == feedID })?.isLikedByCurrentProfile == true
    }
    
    private func updateFeedLikeStateInFeedUIModels(feedID: UUID, like: Bool) {
        if let index = feedUIModels.firstIndex(where: { $0.id == feedID }) {
            feedUIModels[index].isLikedByCurrentProfile = like
            feedUIModels[index].likesCount += like ? 1 : -1
        }
    }
}

// MARK: - Data Processing & Caching For First Time Loading or New Data insetred
extension FeedListViewModel {
    
    private func handleNewFeeds(_ feeds: [Feed]) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask { [weak self] in
                try await self?.updateTheCache(feeds)
            }
            
            group.addTask { [weak self] in
                try await self?.fillfeedLikeUIModels(feeds: feeds)
            }
            
            group.addTask { [weak self] in
                try await self?.fillFeedMediaMetaDatasUIModelCache(feeds: feeds)
            }
            
            try await group.waitForAll()
        }
        
        updateFeedUIModels(feeds)
    }
    
    fileprivate func updateTheCache(_ feeds: [Feed]) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            group.addTask {
                try await self.fillProfileUIModelCache(feeds: feeds)
            }
            
            group.addTask {
                try await self.fillProfilesImageCache(feeds: feeds)
            }
            
            try await group.waitForAll()
        }
    }
    
    private func fillProfileUIModelCache(feeds: [Feed]) async throws {
        let profilesIds = feeds
            .map { $0.profileId }
            .filter { profileUIModelCache[$0] == nil }
        
        guard !profilesIds.isEmpty else { return }
        
        let newProfiles = try await getProfilesUseCase.execute(profileIDs: profilesIds)
        for profile in newProfiles {
            if let profileID = profile.id {
                profileUIModelCache[profileID] = profile.toUIModel()
            }
        }
    }
    
    private func fillProfilesImageCache(feeds: [Feed]) async throws {
        let profileIds = feeds
            .map { $0.profileId }
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
    
    private func fillfeedLikeUIModels(feeds: [Feed]) async throws {
        let feedIDs = feeds
            .map { $0.id }
            .filter { feedId in
                !feedLikes.contains(where: { $0.feedID == feedId })
            }
        
        let fetchedFeedLikes = try await getAllFeedLikesUseCase.execute(feedIDs: feedIDs)
        feedLikes.append(contentsOf: fetchedFeedLikes)
    }
    
    private func fillFeedMediaMetaDatasUIModelCache(feeds: [Feed]) async throws {
        let feedIds = feeds
            .map { $0.id }
            .filter { feedMediaMetaDataUIModelsCache[$0] == nil }
        
        guard !feedIds.isEmpty else { return }
        
        var feedMetaDatasUIModels = try await getFeedMediaDatasUseCase.execute(feedIds: feedIds).map {
            $0.toUIModel()
        }
        
        try await withThrowingTaskGroup(of: (Data?,UUID?).self) { group in
            
            for feedMetaDataUIModel in feedMetaDatasUIModels {
                group.addTask {
                    (try? await self.getActualFeedMediaUseCase.execute(feedMediaDataID: feedMetaDataUIModel.id), feedMetaDataUIModel.id)
                }
            }
            
            for try await (feedImageData, feedMetaDataUIModelId) in group {
                if let feedImageData = feedImageData {
                    if let index = feedMetaDatasUIModels.firstIndex(where: { $0.id == feedMetaDataUIModelId }) {
                        feedMetaDatasUIModels[index].feedImageData = feedImageData
                    }
                }
            }
        }
        
        for feedId in feedIds {
            feedMediaMetaDataUIModelsCache[feedId]?.removeAll()
        }
        
        for feedMetaDataUIModel in feedMetaDatasUIModels {
            if let feedId = feedMetaDataUIModel.feedId {
                self.feedMediaMetaDataUIModelsCache[feedId,default: []].append(feedMetaDataUIModel)
            }
        }
        
    }
    
}


// MARK: - Update Feeds
extension FeedListViewModel {
    
    private func updateExistingFeeds(_ feeds: [Feed]) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            
            group.addTask { [weak self] in
                try await self?.updateFeedUIModelsContents(feeds: feeds)
            }
            
            group.addTask { [weak self] in
                try await self?.updateFeedLikeUIModels(feeds: feeds)
            }
            
            group.addTask { [weak self] in
                try await self?.updateFeedMediaMetaDatasUIModelCache(feeds: feeds)
            }
            
            try await group.waitForAll()
        }
        
        updateFeedUIModels(feeds)
    }
    
    private func updateFeedUIModelsContents(feeds: [Feed]) async throws {
       
        for feed in feeds {
            if let index = self.feedUIModels.firstIndex(where: {  $0.id == feed.id  }) {
                self.feedUIModels[index].content = feed.content
            }
        }
    }
        
    private func updateFeedLikeUIModels(feeds: [Feed]) async throws {
        let feedIDs = feeds
            .map { $0.id }
            
        let fetchedFeedLikes = try await getAllFeedLikesUseCase.execute(feedIDs: feedIDs)
        let fetchedFeedLikesIDS = Set(fetchedFeedLikes.map(\.feedID))
        
        
        for feedId in feedIDs {
            if feedLikes.contains(where: { $0.feedID == feedId }) && !fetchedFeedLikesIDS.contains(feedId) {
                try await unlikeFeedUseCase.execute(feedID: feedId)
                feedLikes.removeAll(where: { $0.feedID == feedId })
            } else if !feedLikes.contains(where: { $0.feedID == feedId }) && fetchedFeedLikesIDS.contains(feedId) {
                if let fetchedFeedLike = fetchedFeedLikes.first(where: { $0.feedID == feedId }) {
                    feedLikes.append(fetchedFeedLike)
                }
            }
         }
    }
    
    private func updateFeedMediaMetaDatasUIModelCache(feeds: [Feed]) async throws {
        let feedIds = feeds
            .map { $0.id }
           
        var feedMetaDatasUIModels = try await getFeedMediaDatasUseCase.execute(feedIds: feedIds).map {
            $0.toUIModel()
        }
        
        try await withThrowingTaskGroup(of: (Data?,UUID?).self) { group in
            
            for feedMetaDataUIModel in feedMetaDatasUIModels {
                group.addTask {
                    (try? await self.getActualFeedMediaUseCase.execute(feedMediaDataID: feedMetaDataUIModel.id), feedMetaDataUIModel.id)
                }
            }
            
            for try await (feedImageData, feedMetaDataUIModelId) in group {
                if let feedImageData = feedImageData {
                    if let index = feedMetaDatasUIModels.firstIndex(where: { $0.id == feedMetaDataUIModelId }) {
                        feedMetaDatasUIModels[index].feedImageData = feedImageData
                    }
                }
            }
        }
        
        for feedId in feedIds {
            feedMediaMetaDataUIModelsCache[feedId]?.removeAll()
        }
        
        for feedMetaDataUIModel in feedMetaDatasUIModels {
            if let feedId = feedMetaDataUIModel.feedId {
                self.feedMediaMetaDataUIModelsCache[feedId,default: []].append(feedMetaDataUIModel)
            }
        }
        
    }
    
}


// MARK: - Delete Feeds
extension FeedListViewModel {
    
    func deleteFeedOperation(feedUIModel: FeedUIModel) {
        Task {
            do {
                try await deleteExistingFeeds([feedUIModel.id])
            } catch {
                print(error)
                print(error.localizedDescription)
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func deleteExistingFeeds(_ feedIDs: [UUID]) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            
            group.addTask { [weak self] in
                try await self?.deleteFeedUIModels(feedIDs: feedIDs)
            }
            
            group.addTask { [weak self] in
                try await self?.deleteFeedLikeUIModels(feedIDs: feedIDs)
            }
            
            group.addTask { [weak self] in
                try await self?.deleteFeedMediaMetaDatasUIModelCache(feedIDs: feedIDs)
            }
            
            try await group.waitForAll()
        }
        
    }
    
    private func deleteFeedUIModels(feedIDs: [UUID]) async throws {
        var deletedFeedIDs: [UUID] = []
        
        try await withThrowingTaskGroup(of: UUID.self) { [weak self] group in
            
            for feedId in feedIDs {
                group.addTask {
                    let fetchedFeedMediaMetaDatas = await self?.feedMediaMetaDataUIModelsCache[feedId] ?? []
                    try await self?.deleteFeedUseCase.execute(feedID: feedId, feedMetaDatas: fetchedFeedMediaMetaDatas)
                    return feedId
                }
            }
            
            for try await deleteFeedID in group {
                deletedFeedIDs.append(deleteFeedID)
            }
        }
        
        feedUIModels.removeAll(where: { deletedFeedIDs.contains($0.id) })
    }
    
    private func deleteFeedLikeUIModels(feedIDs: [UUID]) async throws {
        feedLikes.removeAll(where: { feedIDs.contains($0.feedID) })
    }
    
    private func deleteFeedMediaMetaDatasUIModelCache(feedIDs: [UUID]) async throws {
        for feedId in feedIDs {
            feedMediaMetaDataUIModelsCache[feedId]?.removeAll()
        }
    }
    
}


// MARK: - UI Model Updates
extension FeedListViewModel {
    
    private func updateFeedUIModels(_ sortedFeeds: [Feed]) {
        for feed in sortedFeeds {
            if let index = feedUIModels.firstIndex(where: { $0.id == feed.id }) {
                
                feedUIModels[index].profileUIModel = profileUIModelCache[feed.profileId]
                feedUIModels[index].profileUIModel?.profileImageData = profilesImagesCache[feed.profileId]
                feedUIModels[index].feedMediaMetaDataUIModels = feedMediaMetaDataUIModelsCache[feed.id] ?? []
                
                if let currentProfile = self.currentProfile,
                   let feedLike = feedLikes.first(where: { feedLike in feedLike.feedID == feedUIModels[index].id }) {
                    
                    if feedLike.profileID == currentProfile.id {
                        feedUIModels[index].isLikedByCurrentProfile = true
                    }
                    
                    feedUIModels[index].likesCount += 1
                }
            }
        }
    }
}

