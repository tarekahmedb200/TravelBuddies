//
//  FeedDetailsView.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import SwiftUI

struct FeedDetailsView: View {
    @StateObject var viewModel: FeedDetailViewModel
    
    var body: some View {
        List {
            Section {
                FeedItemView(
                    feedUIModel: viewModel.feedUIModel,
                    clickLikeButton: {
                        viewModel.toggleLikeFeed(feedID: viewModel.feedUIModel.id)
                    },
                    clickProfile: { profileUIModel in
                        // Optional: navigate to profile if needed
                    },
                    onEdit: {
                        viewModel.showUpdateFeed()
                    },
                    onDelete: {
                        viewModel.deleteFeed()
                    }
                )
            }
            
            Section {
                ForEach(viewModel.feedCommentUIModels) { feedCommentUIModel in
                    FeedCommentItemView(feedCommentUIModel: feedCommentUIModel)
                }
            }
        }
        .listStyle(.inset)
        .safeAreaInset(edge: .bottom) {
            FeedCommentInputView(
                feedComment: $viewModel.feedComment,
                profileUIModel: $viewModel.currentProfileUIModel,
                postComment: {
                    viewModel.createFeedComment()
                }
            )
            .frame(height: 70)
            .background(.ultraThinMaterial)
        }
        .toolbar(.hidden, for: .tabBar)
        .task {
            viewModel.loadAllFeedComments()
            viewModel.getCurrentProfile()
            viewModel.observeNewlyInsertedFeedComments()
        }
    }
}

#Preview {
    FeedDetailsView(viewModel: FeedDetailsFactory(coordinator: FeedCoordinator(), feedUIModel: FeedUIModel.mockData[0]).getFeedFeedDetailsViewModel())
}
