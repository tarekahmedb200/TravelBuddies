//
//  ChatDashboardItemView.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import SwiftUI

struct ChatDashboardItemView: View {
    let chatDashboardItem: ChatRoomUIModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 56, height: 56)
                    .overlay(
                        Text(chatDashboardItem.chatRoomName.prefix(1))
                            .font(.title3)
                            .foregroundColor(.white)
                    )
            }
            
            // Chat Room content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(chatDashboardItem.chatRoomName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text(chatDashboardItem.createdAt)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
                
                Text(chatDashboardItem.memberCountText)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.white)
    }
}

#Preview {
    ChatDashboardItemView(chatDashboardItem: ChatRoomUIModel(
        id: UUID(),
        name: "Preview Chat Room",
        memberIDs: [UUID(), UUID(), UUID()],
        createdAt: "2m"
    ))
}
