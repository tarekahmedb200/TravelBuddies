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
    let tags: [TripTag]
    let price: Double
    let adminId: UUID
    var profilesIds: [UUID]
}



extension Trip {
    static let mockData: [Trip] = [
        Trip(
            id: UUID(),
            title: "Desert Safari Adventure",
            description: "Experience dune bashing, camel rides, and Bedouin dinner under the stars.",
            location: "Siwa Oasis, Egypt",
            occurrenceDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())!,
            createdAt: Date(),
            isFree: false,
            maxParticipants: 20,
            tags: [.adventure, .nature, .cultural],
            price: 1200.0,
            adminId: UUID(),
            profilesIds: [UUID(), UUID(), UUID()]
        ),
        Trip(
            id: UUID(),
            title: "Hiking the White Canyon",
            description: "A scenic hike through Sinai’s White Canyon trails — perfect for nature lovers.",
            location: "Sinai, Egypt",
            occurrenceDate: Calendar.current.date(byAdding: .day, value: 10, to: Date())!,
            createdAt: Date(),
            isFree: true,
            maxParticipants: 12,
            tags: [.hiking, .nature, .adventure],
            price: 0.0,
            adminId: UUID(),
            profilesIds: [UUID()]
        ),
        Trip(
            id: UUID(),
            title: "Weekend in Luxor",
            description: "Explore ancient temples and the Valley of the Kings with professional guides.",
            location: "Luxor, Egypt",
            occurrenceDate: Calendar.current.date(byAdding: .day, value: 15, to: Date())!,
            createdAt: Date(),
            isFree: false,
            maxParticipants: 30,
            tags: [.cultural, .city, .family],
            price: 800.0,
            adminId: UUID(),
            profilesIds: [UUID(), UUID()]
        ),
        Trip(
            id: UUID(),
            title: "Nile Kayaking Day",
            description: "Enjoy a calm day kayaking on the Nile — suitable for both beginners and pros.",
            location: "Cairo, Egypt",
            occurrenceDate: Calendar.current.date(byAdding: .day, value: 2, to: Date())!,
            createdAt: Date(),
            isFree: false,
            maxParticipants: 10,
            tags: [.adventure, .nature, .group],
            price: 450.0,
            adminId: UUID(),
            profilesIds: [UUID(), UUID(), UUID(), UUID()]
        ),
        Trip(
            id: UUID(),
            title: "Alexandria Beach Cleanup",
            description: "Join our volunteer group for a beach cleanup and help protect the Mediterranean coast.",
            location: "Alexandria, Egypt",
            occurrenceDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())!,
            createdAt: Date(),
            isFree: true,
            maxParticipants: 50,
            tags: [.beach, .group, .nature],
            price: 0.0,
            adminId: UUID(),
            profilesIds: []
        )
    ]
}
