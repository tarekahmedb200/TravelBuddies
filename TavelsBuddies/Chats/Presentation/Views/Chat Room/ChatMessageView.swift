//
//  ChatMessageView.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import SwiftUI

import SwiftUI

struct ChatMessageView: View {
    let message: ChatMessageUIModel
    
    var isCurrentUser: Bool {
        true
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isCurrentUser {
                Spacer()
            }
            
            // Profile image for other users (left side)
            if !isCurrentUser {
                if let profile = message.profileUIModel {
                    if let profileImage = profile.profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 16))
                            )
                    }
                }
            }

            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                if !isCurrentUser, let profile = message.profileUIModel {
                    Text(profile.username)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading, 4)
                }

                Text(message.text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(isCurrentUser ? Color.blue.opacity(0.9) : Color.gray.opacity(0.2))
                    .foregroundColor(isCurrentUser ? .white : .primary)
                    .cornerRadius(16)
                    .frame(maxWidth: 250, alignment: isCurrentUser ? .trailing : .leading)

                Text(message.createdAt.toString().prefix(16)) // show date or time snippet
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(isCurrentUser ? .trailing : .leading, 8)
            }
            
            // Profile image for current user (right side)
            if isCurrentUser {
                if let profile = message.profileUIModel {
                    if let profileImage = profile.profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 16))
                            )
                    }
                }
            }

            if !isCurrentUser {
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

#Preview {
    ChatMessageView(message: ChatMessageUIModel.mocks[0])
}
