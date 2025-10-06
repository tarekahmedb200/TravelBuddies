//
//  TripListView.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation
import SwiftUI

struct TripListView: View {
    
    @StateObject var viewModel: TripListViewModel
    
    var body: some View {
        List(viewModel.tripUIModels) { trip in
            TripItemView(tripUIModel: trip)
                .listRowSeparator(.hidden) // hide separators
                .listRowInsets(EdgeInsets()) // edge-to-edge cards
                .padding(.vertical, 8)
                .onTapGesture {
                    print("Clicked....")
                    viewModel.navigateToTripDetails(tripUIModel: trip)
                }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.showCreateFeed()
                }) {
                    Text("Create")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .buttonStyle(.glass)

            }
        }
        .navigationTitle("Trips")
        .onAppear {
            viewModel.loadTrips()
        }
    }
}

#Preview {
    NavigationStack { // only for preview
        TripListView(viewModel: TripListFactory(coordinator: TripCoordinator()).getTripListViewModel())
    }
}

