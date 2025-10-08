//
//  TripDetailsView.swift
//  TavelsBuddies
//
//  Created by tarek on 04/10/2025.
//


import SwiftUI

struct TripSubDetailsView: View {
    let tripUIModel: TripUIModel
    let isAdmin : Bool
    var isJoined: Bool = false
    
    var didEnterGroupChat: (() -> Void)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Trip title
            Text(tripUIModel.title)
                .font(.largeTitle)
                .foregroundColor(.primary)
            
            // Admin username
            if let admin = tripUIModel.adminUIModel {
                HStack {
                    
                    if let profileImage = admin.profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.1))
                            .overlay {
                                Text(admin.username.first?.uppercased() ?? "")
                            }
                            .frame(width: 50, height: 50)
                    }
                    
                    Text(admin.username)
                        .font(.title2)
                }
            }
            
            HStack {
                // Location
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.secondary)
                    Text(tripUIModel.location)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Date
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text(tripUIModel.occurrenceDate)
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack {
                HStack {
                    Image(systemName: "person.3.fill")
                        .foregroundColor(.secondary)
                    Text("\(tripUIModel.currentParticipantCount)/\(tripUIModel.maxParticipants) travelers")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isJoined && !isAdmin {
                    Button {
                        didEnterGroupChat()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                                .font(.subheadline)
                            Text("Group Chat")
                                .font(.headline)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                }
                
            }
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack {
                    ForEach(tripUIModel.tags, id: \.self) { tag in
                        Text(tag.rawValue)
                            .font(.headline)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
        }
    }
}

#Preview {
    TripSubDetailsView(tripUIModel:TripUIModel.mockTrips[0], isAdmin: false, didEnterGroupChat: {})
                    
}
