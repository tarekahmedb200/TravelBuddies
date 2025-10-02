//
//  TripListView.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation
import SwiftUI

struct TripListView: View {
    
    @StateObject var viewModel : TripListViewModel
    
    var body: some View {
        List(viewModel.tripUIModels) { trip in
            TripItemView(tripUIModel: trip)
                .listRowSeparator(.hidden) // hide separators
                .listRowInsets(EdgeInsets()) // edge-to-edge cards
                .padding(.vertical, 8)
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Add button action here
                    print("Add tapped")
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                }
            }
        }
        .navigationTitle("Trips")
    }
}

#Preview {
    NavigationStack { // only for preview
        TripListView(viewModel: TripListFactory(coordinator: TripCoordinator()).getTripListViewModel())
    }
}

