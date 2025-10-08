//
//  ChatRoomView.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation
import SwiftUI


struct ChatRoomView: View {
    @StateObject var viewModel : ChatRoomViewModel

    @FocusState private var isInputFocused: Bool
    
    var body: some View {
            VStack(spacing: 0) {
                // Messages List
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.chatMessageUIModels) { chatMessageUIModel in
                                ChatMessageView(chatMessageUIModel: chatMessageUIModel)
                                    .id(chatMessageUIModel.id)
                            }
                        }
                        .padding(.vertical)
                    }
                    .onChange(of: viewModel.chatMessageUIModels.count) { _ in
                        if let lastMessage = viewModel.chatMessageUIModels.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                Divider()
                
                // Message Input
                HStack(spacing: 12) {
                    TextField("Type a message...", text: $viewModel.message)
                        .textFieldStyle(.roundedBorder)
                        .focused($isInputFocused)
                        
                    Button(action: viewModel.sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                           
                    }
            
                }
                .padding()
            }
            .navigationTitle("Chat Room")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        if let image = viewModel.chatRoomUIModel?.chatRoomImage {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 36, height: 36)
                                .foregroundColor(.gray)
                        }

                        Text(viewModel.chatRoomUIModel?.chatRoomName ?? "")
                            .font(.headline)
                    }
                }
            }
        
    }
    
    
}

// MARK: - Preview
#Preview {
    ChatRoomView(viewModel: ChatRoomFactory(coordinator: ChatCoordinator(), chatRoomUIModel: ChatRoomUIModel.mocks[0]).getChatRoomViewModel())
}
