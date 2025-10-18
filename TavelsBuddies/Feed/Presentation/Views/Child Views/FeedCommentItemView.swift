//
//  FeedCommentItemView.swift
//  TavelsBuddies
//
//  Created by tarek on 26/09/2025.
//

import SwiftUI

struct FeedCommentItemView: View {
    
    var feedCommentUIModel: FeedCommentUIModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            avatar
                
            VStack(alignment: .leading, spacing: 10) {
                usernameText
                commentBody
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

private extension FeedCommentItemView {
    var avatar: some View {
        Group {
            if let image = feedCommentUIModel.profileUIModel?.profileImage {
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                    )
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Text(feedCommentUIModel.profileUIModel?.username.first?.uppercased() ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.black.opacity(0.5), lineWidth: 0.5)
                    )
            }
        }
        .frame(width: 40, height: 40)
    }
    
    var usernameText: some View {
        Text(feedCommentUIModel.profileUIModel?.username ?? "")
            .font(.title3)
            .bold()
    }
    
    var commentBody: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(feedCommentUIModel.comment)
            Text(feedCommentUIModel.createdAt)
                .foregroundColor(.gray)
        }
        .font(.headline)
    }
}

#Preview {
    FeedCommentItemView(feedCommentUIModel: FeedCommentUIModel.mockData[0])
}
