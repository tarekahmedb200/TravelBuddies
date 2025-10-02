//
//  TripUIModel.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation
import SwiftUI

struct TripUIModel: Identifiable {
    
    var tripImage: Image? {
        guard let data = tripImageData,
              let uiImage = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
    
    let id: UUID
    let title: String
    let description: String
    let location: String
    let occurrenceDate: String
    let isFree: Bool
    let maxParticipants: Int
    let tags: [String]
    let price: Double
    var adminUIModel: ProfileUIModel?
    let profileUIModels: [ProfileUIModel] = []
    let currentParticipantCount : Int
    var tripImageData : Data?
}

// Mock Trips
extension TripUIModel {
    static let mockTrips: [TripUIModel] = [
        TripUIModel(
            id: UUID(),
            title: "Hiking in the White Desert",
            description: "Join us for a scenic hike through the magical formations of the White Desert. Bring your camera!",
            location: "Farafra Oasis, Egypt",
            occurrenceDate: "2025-10-15 09:00",
            isFree: false,
            maxParticipants: 20,
            tags: ["Hiking", "Adventure", "Nature"],
            price: 50.0,
            adminUIModel: ProfileUIModel.mockData[2],
            currentParticipantCount: 8
        ),
        TripUIModel(
            id: UUID(),
            title: "Nile Felucca Ride",
            description: "Relax and enjoy a traditional felucca ride on the Nile at sunset.",
            location: "Cairo, Egypt",
            occurrenceDate: "2025-10-20 17:30",
            isFree: true,
            maxParticipants: 10,
            tags: ["Boat Ride", "Culture", "Relax"],
            price: 0.0,
            adminUIModel: ProfileUIModel.mockData[1],
            currentParticipantCount: 5
        ),
        TripUIModel(
            id: UUID(),
            title: "Desert Safari Adventure",
            description: "An adrenaline-filled desert safari with dune bashing and Bedouin camp dinner.",
            location: "Giza Desert, Egypt",
            occurrenceDate: "2025-11-01 15:00",
            isFree: false,
            maxParticipants: 15,
            tags: ["Safari", "Adventure", "Culture"],
            price: 120.0,
            adminUIModel: ProfileUIModel.mockData[0],
            currentParticipantCount: 12
        )
    ]
}



extension Trip {
    func toUIModel() -> TripUIModel {
        return TripUIModel(
            id: id,
            title: title,
            description: description,
            location: location,
            occurrenceDate: occurrenceDate.toString(),
            isFree: isFree,
            maxParticipants: maxParticipants,
            tags: tags,
            price: price,
            currentParticipantCount: profilesIds.count
        )
    }
}

