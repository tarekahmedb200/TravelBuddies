//
//  Feed.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation

struct Feed {
    var id: UUID = UUID()
    var content: String
    var createdAt: Date = Date()
    var profileId: UUID
}

