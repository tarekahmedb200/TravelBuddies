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
            
            if let profileImage = feedCommentUIModel.profileUIModel?.profileImage {
                profileImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .border(Color.black, width: 0.5)
            }else {
                Circle()
                    .fill(Color.gray)
                    .stroke(Color.black, lineWidth: 0.5)
                    .overlay {
                        Text(feedCommentUIModel.profileUIModel?.username.first?.uppercased() ?? "")
                    }
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading,spacing: 10) {
                Text(feedCommentUIModel.profileUIModel?.username ?? "")
                    .font(.title3)
                    .bold()
                
                VStack(alignment: .leading,spacing: 15) {
                    Text(feedCommentUIModel.content)
                    
                    Text(feedCommentUIModel.createdAt)
                        .foregroundColor(.gray)
                }
                .font(.headline)
                
                
            }
            
            Spacer()
        }
        .padding(.horizontal)
        
        
    }
}

#Preview {
    FeedCommentItemView(feedCommentUIModel: FeedCommentUIModel.mockData[0])
}
