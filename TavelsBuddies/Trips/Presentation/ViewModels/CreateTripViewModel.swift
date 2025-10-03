//
//  CreateTripViewModel.swift
//  TavelsBuddies
//
//  Created by tarek on 03/10/2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class CreateTripViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let createTripFlowUseCase: CreateTripFlowUseCase
    
    // MARK: - Input Fields (bound to UI)
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var location: String = ""
    @Published var occurrenceDate: Date = Date()
    @Published var isFree: Bool = false
    @Published var maxParticipants: Int = 0
    @Published var tags: [TripTag] = []
    @Published var price: Double = 0.0
    @Published var imageData: Data? = nil
    
    // MARK: - State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isSuccess: Bool = false
    
    // MARK: - Init
    init(createTripFlowUseCase: CreateTripFlowUseCase) {
        self.createTripFlowUseCase = createTripFlowUseCase
    }
    
    // MARK: - Actions
    func createTrip() async {
        guard let imageData = imageData else {
            errorMessage = "Please select an image"
            return
        }
        
        isLoading = true
        errorMessage = nil
        isSuccess = false
        
        do {
            try await createTripFlowUseCase.execute(
                title: title,
                description: description,
                location: location,
                occurrenceDate: occurrenceDate,
                isFree: isFree,
                maxParticipants: maxParticipants,
                tags: tags,
                price: price,
                imageData: imageData
            )
            isSuccess = true
        } catch {
            print(error)
            print(error.localizedDescription)
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func isTagSelected(_ tag: TripTag) -> Bool {
        tags.contains(tag)
    }
    
    func insertTag(_ tag: TripTag) {
        tags.append(tag)
    }
    
    func removeTag(_ tag: TripTag) {
        tags.removeAll { $0 == tag }
    }
    
}
