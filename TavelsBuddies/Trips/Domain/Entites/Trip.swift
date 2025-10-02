//
//  Trip.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation

struct Trip {
    let id: UUID
    let title: String
    let description: String
    let location: String
    let occurrenceDate: Date
    let createdAt: Date
    let isFree: Bool
    let maxParticipants: Int
    let tags: [String]
    let price: Double
    let adminId: UUID
    let profilesIds: [UUID]
}
