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
    case feedMediaMetaData = "FeedMediaMetaData"
    case feedLike = "FeedLike"
    case feedComment = "FeedComment"
    case trip = "Trip"
    case chatMessage = "ChatMessage"
    case chatRoom = "ChatRoom"
}

enum SupabaseStorageNames: String {
    case profileImages = "ProfileImages"
    case feedImages = "FeedImages"
    case feedVideos = "FeedVideos"
    case tripImage = "TripImages"
    case chatRoomImages = "ChatRoomImages"
}
