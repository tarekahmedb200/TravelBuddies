//
//  MemberTripDetailsView.swift
//  TavelsBuddies
//
//  Created by tarek on 03/10/2025.
//

import SwiftUI

struct MemberTripDetailsView: View {
    
    @StateObject var viewModel: MemberTripDetailsViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 10) {
                
                TripImageView(tripUIModel: viewModel.tripUIModel)
                    .frame(maxWidth: .infinity)
                    .containerRelativeFrame(.vertical) { length, _ in
                        length * 0.5
                    }
                    
                TripSubDetailsView(tripUIModel: viewModel.tripUIModel)
                    .padding()
                
                TripDetailSegmentedView(tabs: [
                    SegmentedTab(
                        title: "Overview",
                        view: AnyView(TripDescriptionView(description: viewModel.tripUIModel.description))
                    ),
                    SegmentedTab(
                        title: "Participants",
                        view: AnyView(TripParticipantsView(membersUIModels: viewModel.profileUIModels))
                    ),
                    
                    SegmentedTab(
                        title: "Contact",
                        view: AnyView(TripOrganizerContactView(adminUIModel: viewModel.tripUIModel.adminUIModel))
                    )
                ])
                
                .containerRelativeFrame(.vertical) { length, _ in
                    length * 0.5
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                
                Button(action: {
                    viewModel.handleJoiningTrip()
                }) {
                    Text(viewModel.checkIfJoined() ? "Leave Trip" : "Join Trip")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Color.MainComponentColor
                                .cornerRadius(8)
                        )
                }
                .buttonStyle(.plain)
            }
        }.onAppear {
            viewModel.getCurrentProfile()
            viewModel.getProfiles()
        }
    }
    
}

#Preview {
    NavigationStack {
        MemberTripDetailsView(viewModel: MemberTripDetailsFactory(coordinator: TripCoordinator(), tripUIModel: TripUIModel.mockTrips[0]).getMemberTripDetailsViewModel())
    }
}
