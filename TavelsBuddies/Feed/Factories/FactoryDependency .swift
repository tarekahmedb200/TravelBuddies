//
//  FactoryDependency .swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation

final class FactoryDependency {
        
    // Repositories
    lazy var authenticationRepository: any AuthenticationRepository = {
        AuthenticationRepositoryImplementation(
            authenticationService: authService,
            userAuthenticationInfoCacheService: userAuthCache
        )
    }()
    
    lazy var feedRepository: any FeedRepository = {
        FeedRepositoryImplementation(
            feedService: feedService,
            authenticationService: authService
        )
    }()
    
    lazy var feedCommentRepository: any FeedCommentRepository = {
        FeedCommentRepositoryImplementation(
            feedCommentService: feedCommentService
        )
    }()
    
    lazy var feedLikeRepository: any FeedLikeRepository = {
        FeedLikeRepositoryImplementation(
            feedLikeService: feedLikeService,
            authenticationService: authService
        )
    }()
    
    lazy var feedMediaRepository: any FeedMediaRepository = {
        FeedMediaRepositoryImplementation(
            feedMediaService: feedMediaService,
            authenticationService: authService
        )
    }()
    
    // Profile Factory (reuse existing implementation)
    lazy var profileFactory: ProfileFactory = {
        ProfileFactory()
    }()
    
    
    // MARK: - Services
    lazy var feedService: FeedService = {
        SupabaseFeedServiceImplementation()
    }()
    
    lazy var feedCommentService: FeedCommentService = {
        SupabaseFeedCommentServiceImplementation()
    }()
    
    lazy var feedLikeService: FeedLikeService = {
        SupabaseFeedLikeServiceImplementation()
    }()
    
    lazy var feedMediaService: FeedMediaService = {
        SupabaseFeedMediaServiceImplementation()
    }()
    
    lazy var authService: AuthenticationService = {
        SupabaseAuthenticationServiceImplementation()
    }()
    
    lazy var userAuthCache: UserAuthenticationInfoCacheService = {
        UserDefaultsCacheService()
    }()
    
    // MARK: - Feed Use Cases
    
    // Feeds list and stream
    func makeObserveNewlyInsertedFeedsUseCase() -> any ObserveNewlyInsertedFeedsUseCase {
        ObserveNewlyInsertedFeedsUseCaseImplementation(feedRepository: feedRepository)
    }
    
    func makeGetAllFeedsUseCase() -> any GetAllFeedsUseCase {
        GetAllFeedsUseCaseImplementation(feedRepository: feedRepository)
    }
    
    // Likes
    func makeGetAllFeedsLikesUseCase() -> any GetAllFeedsLikesUseCase {
        GetAllFeedsLikesUseCaseImplementation(feedLikeRepository: feedLikeRepository)
    }
    
    func makeLikeFeedUseCase() -> any LikeFeedUseCase {
        LikeFeedUseCaseImplementation(feedLikeRepository: feedLikeRepository)
    }
    
    func makeUnLikeFeedUseCase() -> any UnLikeFeedUseCase {
        UnLikeFeedUseCaseImplementation(feedLikeRepository: feedLikeRepository)
    }
    
    // Media
    func makeGetActualFeedMediaUseCase() -> any GetActualFeedMediaUseCase {
        GetActualFeedMediaUseCaseImplementation(feedMediaRepository: feedMediaRepository)
    }
    
    // Create Feed
    func makeCreateFeedUseCase() -> any CreateFeedUseCase {
        CreateFeedUseCaseImplementation(
            createFeedMediaMetaDataUseCase: makeCreateFeedMediaMetaDataUseCase(),
            uploadActualFeedMediaUseCase: makeUploadActualFeedMediaUseCase(),
            feedRepository: feedRepository,
            authenticationRepository: authenticationRepository)
    }
    
    //Media
    func makeCreateFeedMediaMetaDataUseCase() -> any CreateFeedMediaMetaDataUseCase {
        return CreateFeedMediaMetaDataUseCaseImplementation(feedMediaRepository: feedMediaRepository)
    }
    
    func makeFeedMediaDatasUseCase() -> any GetFeedMediaDatasUseCase {
        return GetFeedMediaDatasUseCaseImplementation(feedMediaRepository: feedMediaRepository)
    }
    
    func makeUploadActualFeedMediaUseCase() -> any UploadActualFeedMediaUseCase {
        UploadActualFeedMediaUseCaseImplementation(
            feedMediaRepository: feedMediaRepository
        )
    }
    
    // Comments
    func makeCreateFeedCommentUseCase() -> any CreateFeedCommentUseCase {
        CreateFeedCommentUseCaseImplementation(
            feedCommentRepository: feedCommentRepository,
            authenticationRepository: authenticationRepository
        )
    }
    
    func makeGetAllFeedCommentsUseCase() -> any GetAllFeedCommentsUseCase {
        GetAllFeedCommentsUseCaseImplementation(feedCommentRepository: feedCommentRepository)
    }
    
    func makeObserveNewlyInsertedFeedCommentsUseCase() -> any ObserveNewlyInsertedFeedCommentsUseCase {
        ObserveNewlyInsertedFeedCommentsUseCaseImplementation(feedCommentRepository: feedCommentRepository)
    }
}
