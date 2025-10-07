//
//  ChatCoordinator.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation
import SwiftUI
import Combine


final class ChatCoordinator: ObservableObject, ChatCoordinating {
    
    @Published var path = NavigationPath()
    @Published var fullScreenPage: FullScreenChatPages?
    
    func push(to page: NavigationChatPages) {
        path.append(page)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func navigate(to page: NavigationChatPages) -> some View {
        switch page {
        case .chatDashboard:
            ChatDashboardFactory(coordinator: self).getChatDashBoardView()
        case .chatRoom(let chatRoomUIModel):
            ChatRoomFactory(coordinator: self, chatRoomUIModel: chatRoomUIModel).getChatRoomView()
        }
    }
    
    func presentFullScreenCover(_ page: FullScreenChatPages) {
        self.fullScreenPage = page
    }
    
    func dismissFullScreenCover() {
        self.fullScreenPage = nil
    }
    
    @ViewBuilder
    func showFullScreenCover(_ page: FullScreenChatPages) -> some View {
        
        switch fullScreenPage {
        case .createChatRoom:
           EmptyView()
        case .none:
            EmptyView()
        }
    }
}
