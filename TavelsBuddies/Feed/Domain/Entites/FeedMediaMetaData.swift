//
//  FeedMediaMetaData.swift
//  TavelsBuddies
//
//  Created by tarek on 16/10/2025.
//

import Foundation

struct FeedMediaMetaData: Codable {
    var id : UUID
    var feedId : UUID
    var mediaType : MediaType
}
