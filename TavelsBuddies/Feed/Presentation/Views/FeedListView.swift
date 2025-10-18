//
//  FeedListView.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import SwiftUI

struct FeedListView: View {
    
    @StateObject var viewModel: FeedListViewModel
    
    var body: some View {
        
        List(viewModel.feedUIModels) { feedUIModel in
            FeedItemView(
                feedUIModel: feedUIModel,
                clickLikeButton: {
                    viewModel.toggleLikeFeed(feedID: feedUIModel.id)
                }
                , clickCommentButton: {
                    viewModel.navigateToFeedDetails(feedUIModel: feedUIModel)
                },clickProfile: { profileUIModel in
                    viewModel.enterProfileDetails(profileUIModel: profileUIModel)
                } , onEdit:  {
                    
                } , onDelete: {
                    
                }
            )
        }
        .onAppear {
            viewModel.loadFeeds()
            viewModel.getCurrentProfile()
            viewModel.observeNewlyInsertedFeeds()
        }
        .listStyle(.inset)
        .navigationTitle(Text("Feeds"))
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.showCreateFeed()
                }) {
                    Text("Add Feed")
                        .font(.callout)
                        .foregroundStyle(Color.white)
                }
                .padding()
                .background(Color.blue)
            }
        }
        
        
    }
}

#Preview {
    FeedListView(viewModel: FeedListFactory(coordinator: FeedCoordinator()).getFeedListViewModel())
}
