//
//  TripItemView.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import SwiftUI

struct TripItemView: View {
    let tripUIModel: TripUIModel
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            
            // Top image with price overlay
            ZStack(alignment: .topLeading) {
                Image("treeImage") // Replace with trip image if available
                    .resizable()
                    .clipped()
                
                Text(tripUIModel.price, format: .currency(code: "USD"))
                    .font(.subheadline)
                    .bold()
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(8)
            }
            .frame(maxWidth: .infinity)
            .containerRelativeFrame(.vertical) { length, _ in
                length * 0.5
            }
            
            VStack(alignment: .leading,spacing: 15) {
                // Trip title
                Text(tripUIModel.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Admin username
                if let admin = tripUIModel.adminUIModel {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.secondary)
                        Text(admin.username)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Location
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.secondary)
                    Text(tripUIModel.location)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Date
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text(tripUIModel.occurrenceDate)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Travelers
                HStack {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(.secondary)
                    Text("\(tripUIModel.currentParticipantCount)/\(tripUIModel.maxParticipants) travelers")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Tags
                HStack {
                    ForEach(tripUIModel.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            .padding()
            
            
        }

        .background(
            Color(.systemBackground) // opaque background (white in light mode, black in dark mode)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
        
    }
}

#Preview {
    TripItemView(tripUIModel: TripUIModel.mockTrips[0])
}

