//
//  FeedMediaMetaDataUIModel.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation
import SwiftUI

struct FeedMediaMetaDataUIModel: Identifiable {
    var id : UUID
    var feedId : UUID?
    var mediaType : MediaType
    var feedImageData : Data?
     
    var feedImage: Image? {
        guard let data = feedImageData,
            let uiImage = UIImage(data: data) else {
            return nil
        }
        
        return Image(uiImage: uiImage)
    }
}

extension FeedMediaMetaDataUIModel {
    func toDomain() -> FeedMediaMetaData? {
        
        guard let feedId = feedId else {
            return nil
        }
        
        return FeedMediaMetaData(
            id: id,
            feedId: feedId,
            mediaType: mediaType
        )
    }
}

extension FeedMediaMetaData {
    func toUIModel() -> FeedMediaMetaDataUIModel {
        FeedMediaMetaDataUIModel(
            id: id,
            feedId: feedId,
            mediaType: mediaType
        )
    }
}
