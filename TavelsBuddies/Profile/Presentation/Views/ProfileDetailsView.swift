//
//  ProfileDetailsView.swift
//  TavelsBuddies
//
//  Created by tarek on 08/10/2025.
//

import SwiftUI

struct ProfileDetailsView: View {
    let viewModel: ProfileDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                // Header with gradient background
                VStack(alignment: .leading) {
                    LinearGradient(
                        colors: [Color(hex: "C4C4C4"), Color(hex: "F5E6D3")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(maxWidth: .infinity)
                    .containerRelativeFrame(.vertical) { length, _ in
                        length * 0.2
                    }
                    
                    HStack {
                        Group {
                            if let profileImage = viewModel.profileUIModel.profileImage {
                                profileImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 4)
                                    )
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(.gray)
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 4)
                                    )
                            }
                        }
                        .padding(.horizontal)
                        .offset(y: -60)
                        .padding(.bottom, -60)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            HStack(spacing: 8) {
                                Image(systemName: "message.fill")
                                    .font(.system(size: 16))
                                Text("Message")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(height: 50)
                            .frame(width: 150)
                            .background(Color(hex: "4A9EFF"))
                            .cornerRadius(24)
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Profile content
                VStack(alignment: .leading, spacing: 16) {
                        
                    Text(viewModel.profileUIModel.username.capitalized)
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                    
                    // Description
                    if let description = viewModel.profileUIModel.description {
                        Text(description)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Location and join date
                    HStack(spacing: 20) {
                        HStack(spacing: 6) {
                            Image(systemName: "mappin.circle")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Text(viewModel.profileUIModel.address)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Text("Joined Jan 2023")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding()
                
            }
            
        }
        .ignoresSafeArea(edges: .top)
    }
}

// Helper extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// Preview
#Preview {
    ProfileDetailsView(viewModel: ProfileDetailsFactory(coordinator: ProfileCoordinator(), profileUIModel: ProfileUIModel.mockData[0]).getProfileDetailsViewModel())
}
