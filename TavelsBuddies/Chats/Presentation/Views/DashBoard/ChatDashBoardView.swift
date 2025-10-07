//
//  ChatDashBoardView.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation
import SwiftUI


// MARK: - Messages View
struct ChatDashBoardView: View {
    @StateObject var viewModel: ChatDashboardViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.chatRoomUIModels) { chatRoomUIModel in
                            ChatDashboardItemView(chatDashboardItem: chatRoomUIModel)
                        }
                    }
                }
            }
            .navigationTitle("Chat DashBoard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.blue)
                    }
                }
            }
            .onAppear {
                viewModel.loadChatRooms()
            }
        }
    }
}

#Preview {
    ChatDashBoardView(viewModel: ChatDashboardFactory(coordinator: ChatCoordinator()).getChatDashboardViewModel())
}


