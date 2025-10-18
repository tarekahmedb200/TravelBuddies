//
//  FeedComment.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation


struct FeedComment {
    var id: UUID = UUID()
    let profileID: UUID
    var comment: String
    var createdAt: Date = Date()
    let feedID: UUID
}

   
