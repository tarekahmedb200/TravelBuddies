//
//  FeedListViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation
import Combine

@MainActor
class FeedListViewModel : ObservableObject {
    
    @Published var feedUIModels = [FeedUIModel]()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let getAllFeedsUseCase: GetAllFeedsUseCase
    
    
    private let observeNewlyInsertedFeedsUseCase: ObserveNewlyInsertedFeedsUseCase
    
    private let getAllFeedLikesUseCase: GetAllFeedsLikesUseCase
    private let likeFeedUseCase: LikeFeedUseCase
    private let unlikeFeedUseCase: UnLikeFeedUseCase
    
    private let getFeedMediaUseCase: GetFeedMediaUseCase
    
    private let getProfilesUseCase : GetProfilesUseCase
    private let getCurrentProfileUseCase : GetCurrentProfileUseCase
    
    private let getProfileImageUseCase : GetProfileImageUseCase
    private var currentProfile: Profile?
    
    private let coordinator: any FeedCoordinating
    
    private var profileUIModelCache: [UUID: ProfileUIModel] = [:]
    private var profilesImagesCache: [UUID: Data] = [:]
    private var feedLikes =  [FeedLike]()
    
    init(getAllFeedsUseCase: GetAllFeedsUseCase, getAllFeedLikesUseCase: GetAllFeedsLikesUseCase, likeFeedUseCase: LikeFeedUseCase, unlikeFeedUseCase: UnLikeFeedUseCase, getFeedMediaUseCase: GetFeedMediaUseCase, getProfilesUseCase: GetProfilesUseCase, getCurrentProfileUseCase: GetCurrentProfileUseCase, getProfileImageUseCase: GetProfileImageUseCase,observeNewlyInsertedFeedsUseCase: ObserveNewlyInsertedFeedsUseCase, coordinator: any FeedCoordinating) {
        self.getAllFeedsUseCase = getAllFeedsUseCase
        self.getAllFeedLikesUseCase = getAllFeedLikesUseCase
        self.likeFeedUseCase = likeFeedUseCase
        self.unlikeFeedUseCase = unlikeFeedUseCase
        self.getFeedMediaUseCase = getFeedMediaUseCase
        self.getProfilesUseCase = getProfilesUseCase
        self.getCurrentProfileUseCase = getCurrentProfileUseCase
        self.getProfileImageUseCase = getProfileImageUseCase
        self.observeNewlyInsertedFeedsUseCase = observeNewlyInsertedFeedsUseCase
       
        self.coordinator = coordinator
    }
    
    func getCurrentProfile() {
        Task {
            do {
                currentProfile = try await getCurrentProfileUseCase.execute()
            } catch  {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func observeNewlyInsertedFeeds() {
        Task {
            for await feed in observeNewlyInsertedFeedsUseCase.execute() {
                let uiModel = feed.toUImodel()
                feedUIModels.insert(uiModel, at: 0)
                try await handleNewFeeds([feed])
            }
        }
    }

    func toggleLikeFeed(feedID: UUID)  {
        
        Task {
            do {
                
                if await checkIfFeedIsLiked(feedID: feedID) {
                    try await unlikeFeedUseCase.execute(feedID: feedID)
                    updateFeedLikeStateInFeedUIModels(feedID: feedID, like: false)
                }else {
                    try await likeFeedUseCase.execute(feedID: feedID)
                    updateFeedLikeStateInFeedUIModels(feedID: feedID, like: true)
                }
                
            } catch  {
                print(error)
                print(error.localizedDescription)
            }
        }
    }
    
    private func checkIfFeedIsLiked(feedID: UUID) async -> Bool {
        return feedUIModels.first(where: { $0.id == feedID })?.isLikedByCurrentProfile == true
    }
    
    private func updateFeedLikeStateInFeedUIModels(feedID: UUID,like:Bool) {
        if let index = feedUIModels.firstIndex(where: { $0.id == feedID }) {
            feedUIModels[index].isLikedByCurrentProfile = like
            feedUIModels[index].likesCount +=  like ? 1 : -1
        }
    }
    
    func navigateToFeedDetails(feedUIModel:FeedUIModel) {
        coordinator.push(to: .feedDetails(feed: feedUIModel))
    }
    
    func showCreateFeed() {
        coordinator.presentFullScreenCover(.createFeed)
    }
    
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
    
    private func handleNewFeeds(_ feeds: [Feed]) async throws  {
        
        try await withThrowingTaskGroup(of: Void.self) { group in
            
            group.addTask { [weak self ] in
                try await self?.updateTheCache(feeds)
            }
            
            group.addTask { [weak self ] in
                try await self?.fillfeedLikeUIModels(feeds: feeds)
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
    
    private func fillProfileUIModelCache(feeds:[Feed]) async throws {
        
        let profilesIds = feeds
            .map { $0.profileId }
            .filter { profileUIModelCache[$0] == nil }
        
        guard !profilesIds.isEmpty else {return }
        
        let newProfiles = try await getProfilesUseCase.execute(profileIDs: profilesIds)
        for profile in newProfiles {
            if let profileID = profile.id {
                profileUIModelCache[profileID] = profile.toUIModel()
            }
        }
    }
    
    private func fillProfilesImageCache(feeds: [Feed]) async throws {
        // Collect only missing profile IDs
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
    
    private func fillfeedLikeUIModels(feeds:[Feed]) async throws {
        let feedIDs = feeds.map { $0.id }
        feedLikes = try await getAllFeedLikesUseCase.execute(feedIDs: feedIDs)
    }
    
    private func updateFeedUIModels(_ sortedFeeds: [Feed]) {
        
        for feed in sortedFeeds {
            if var index = feedUIModels.firstIndex(where: { $0.id == feed.id }) {
                
                feedUIModels[index].profileUIModel = profileUIModelCache[feed.profileId]
                feedUIModels[index].profileUIModel?.profileImageData = profilesImagesCache[feed.profileId]
                
                if let currentProfile = self.currentProfile,
                   let feedLike = feedLikes.first(where: { feedLike in feedLike.feedID == feedUIModels[index].id })  {
                    
                    if feedLike.profileID == currentProfile.id {
                        feedUIModels[index].isLikedByCurrentProfile = true
                    }
                    
                    feedUIModels[index].likesCount += 1
                }
                
            }
        }
        
    }
    
    
    
}




