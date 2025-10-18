//
//  UploadActualFeedMediaUseCase.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation


protocol UploadActualFeedMediaUseCase {
    func execute(feedMediaDataID: UUID,feedMediaData:Data) async throws
}

class UploadActualFeedMediaUseCaseImplementation {
    private let feedMediaRepository: FeedMediaRepository
    
    init(feedMediaRepository: FeedMediaRepository) {
        self.feedMediaRepository = feedMediaRepository
    }
}

extension UploadActualFeedMediaUseCaseImplementation : UploadActualFeedMediaUseCase {
    func execute(feedMediaDataID: UUID,feedMediaData:Data) async throws  {
        
        guard let compressedMediaData = await ImageCompressor.resizeAndCompress(feedMediaData) else {
            return
        }
        
        return try await feedMediaRepository.uploadFeedActualMedia(feedMediaDataID: feedMediaDataID, mediaData: compressedMediaData)
    }
}
