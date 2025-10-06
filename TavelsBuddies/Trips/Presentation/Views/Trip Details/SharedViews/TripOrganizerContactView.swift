//
//  TripOrganizerContactView.swift
//  TavelsBuddies
//
//  Created by tarek on 03/10/2025.
//

import SwiftUI

struct TripOrganizerContactView: View {
    
    var adminUIModel: ProfileUIModel?
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .center,spacing: 20) {
                
                HStack(alignment: .center,spacing: 15) {
                    if let profileImage = adminUIModel?.profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.1))
                            .overlay {
                                Text(adminUIModel?.username.first?.uppercased() ?? "")
                            }
                            .frame(width: 100, height: 100)
                    }
                    
                    Text(adminUIModel?.username ?? "")
                        .font(.title)
                    
                    Spacer()
                }
                
                
                
                Group {
                    HStack {
                        Image(systemName: "phone")
                            .font(.headline)
                        
                        Text("+1 234 567 8900")
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    
                    
                    
                    // Email Cell
                    HStack {
                        Image(systemName: "envelope")
                            .font(.headline)
                        
                        Text("maria@example.com")
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                    
                    
                    // Message Button Cell
                    Button(action: {
                        // Navigate to chat screen
                        // You can implement navigation here
                    }) {
                        HStack {
                            Image(systemName: "message")
                                .font(.headline)
                            
                            Text("Send Message")
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                    
                }
                .padding()
                .background(Color(red: 250/255, green: 250/255, blue: 250/255) )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                
                
                
                
            }
            .padding()
            
            
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TripOrganizerContactView(adminUIModel: ProfileUIModel.mockData[0])
}
