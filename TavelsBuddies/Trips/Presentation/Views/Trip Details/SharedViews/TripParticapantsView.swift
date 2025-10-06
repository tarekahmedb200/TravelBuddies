//
//  TripParticapantsView.swift
//  TavelsBuddies
//
//  Created by tarek on 03/10/2025.
//

import SwiftUI

struct TripParticipantsView: View {
    
    var membersUIModels: [ProfileUIModel] = []
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Participants")
                .font(.title2)
                .bold()
            
            List(membersUIModels,id: \.id) { member in
                
                HStack {
                    // Circular image
                    if let profileImage = member.profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.1))
                            .overlay {
                                Text(member.username.first?.uppercased() ?? "")
                                    .font(.title2)
                            }
                            .frame(width: 50, height: 50)
                    }
                    
                    // VStack with username
                    VStack(alignment: .leading, spacing: 4) {
                        Text(member.username)
                            .font(.headline)
                        
                        Text("gg@gmail.com")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                    }
                    
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TripParticipantsView(membersUIModels: ProfileUIModel.mockData)
}
