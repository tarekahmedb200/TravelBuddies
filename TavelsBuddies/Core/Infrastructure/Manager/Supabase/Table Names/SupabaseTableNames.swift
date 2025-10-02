//
//  SupabaseTableNames.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation


enum SupabaseTableNames : String {
    case profile = "Profile"
    case feed = "Feed"
    case feedLike = "FeedLike"
    case feedComment = "FeedComment"
    case trip = "Trip"
}

enum SupabaseStorageNames: String {
    case profileImages = "Profile_Images"
    case feedImages = "Feed_Images"
    case feedVideos = "Feed_Videos"
    case tripImage = "Trip_Images"
}
