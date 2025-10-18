//
//  FeedItemView.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation
import SwiftUI

struct FeedItemView: View {
    // MARK: - Properties
    
    let feedUIModel: FeedUIModel
    let clickLikeButton: () -> Void
    let clickCommentButton: (() -> Void)?
    let clickProfile: (ProfileUIModel) -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let showCommentButton: Bool
    
    private let maxVisibleImages = 3
    
    init(
        feedUIModel: FeedUIModel,
        clickLikeButton: @escaping () -> Void,
        clickCommentButton: (() -> Void)? = nil,
        clickProfile: @escaping (ProfileUIModel) -> Void,
        onEdit: @escaping () -> Void,
        onDelete: @escaping () -> Void,
        showCommentButton: Bool = true
    ) {
        self.feedUIModel = feedUIModel
        self.clickLikeButton = clickLikeButton
        self.clickCommentButton = clickCommentButton
        self.clickProfile = clickProfile
        self.onEdit = onEdit
        self.onDelete = onDelete
        self.showCommentButton = showCommentButton
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 20) {
            headerSection
            contentSection
            footerSection
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        HStack(spacing: 20) {
            profileImageView
            profileInfoView
            Spacer()
            menuButton
        }
        .padding(.horizontal)
        .contentShape(Rectangle())
        .onTapGesture {
            if let profileUIModel = feedUIModel.profileUIModel {
                clickProfile(profileUIModel)
            }
        }
    }
    
    @ViewBuilder
    private var profileImageView: some View {
        if let profileImage = feedUIModel.profileUIModel?.profileImage {
            profileImage
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
        } else {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .overlay {
                    Text(feedUIModel.profileUIModel?.username.first?.uppercased() ?? "")
                        .foregroundStyle(Color.primary)
                }
                .frame(width: 50, height: 50)
        }
    }
    
    private var profileInfoView: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(feedUIModel.profileUIModel?.username ?? "")
                .font(.title3)
                .bold()
            
            Text(feedUIModel.createAt)
                .font(.headline)
                .foregroundStyle(Color.gray)
        }
    }
    
    private var menuButton: some View {
        Menu {
            Button {
                onEdit()
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                onDelete()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .rotationEffect(.degrees(90))
                .foregroundStyle(Color.gray)
                .font(.title2)
                .padding(.trailing, 8)
        }
        .buttonStyle(.borderless)
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(spacing: 15) {
            
            if feedUIModel.hasMedia {
                imagesSection
            }else {
                contentText
            }
        }
        .padding(.horizontal)
    }
    
    private var contentText: some View {
        Text(feedUIModel.content)
            .font(.title3)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding()
    }
    
    private var imagesSection: some View {
        
        VStack(alignment: .leading) {
            
            if !feedUIModel.content.isEmpty {
                Text(feedUIModel.content)
                    .font(.title3)
                    .frame(alignment: .leading)
                    .padding()
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(feedUIModel.feedMediaMetaDataUIModels) { imageMetaData in
                        if let image = imageMetaData.feedImage {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 250, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .clipped()
                        }
                    }
                }
                .padding(.horizontal, 1)
            }
        }
    }
    
    // MARK: - Footer Section
    
    private var footerSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            actionButtons
            likesCountView
        }
        .padding(.horizontal)
    }
    
    private var actionButtons: some View {
        HStack(spacing: 30) {
            likeButton
            
            if showCommentButton {
                commentButton
            }
            
            Spacer()
        }
        .font(.title2)
    }
    
    private var likeButton: some View {
        Button {
            clickLikeButton()
        } label: {
            Image(systemName: feedUIModel.isLikedByCurrentProfile ? "heart.fill" : "heart")
                .foregroundStyle(feedUIModel.isLikedByCurrentProfile ? Color.red : Color.gray)
                .scaleEffect(feedUIModel.isLikedByCurrentProfile ? 1.0 : 0.9)
        }
        .buttonStyle(.borderless)
        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: feedUIModel.isLikedByCurrentProfile)
    }
    
    private var commentButton: some View {
        Button {
            clickCommentButton?()
        } label: {
            Image(systemName: "bubble.left")
                .foregroundStyle(Color.gray)
        }
        .buttonStyle(.borderless)
    }
    
    private var likesCountView: some View {
        HStack {
            Text("\(feedUIModel.likesCount) Likes")
                .font(.callout)
                .bold()
            
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    FeedItemView(
        feedUIModel: FeedUIModel.mockData[0],
        clickLikeButton: {},
        clickCommentButton: {},
        clickProfile: { _ in },
        onEdit: { print("Edit tapped") },
        onDelete: { print("Delete tapped") }
    )
}
