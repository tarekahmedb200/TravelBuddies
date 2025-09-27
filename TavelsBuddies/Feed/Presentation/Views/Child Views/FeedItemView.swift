//
//  FeedItemView.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation
import SwiftUI

struct FeedItemView: View {
    var feedUIModel: FeedUIModel
    var clickLikeButton: () -> Void
    var clickCommentButton: (() -> Void)?
    var showCommentButton : Bool = true
    
    var body: some View {
        
        VStack(spacing:30) {
            //Header :
            
            HStack(spacing: 20) {
                
                if let profileImage = feedUIModel.profileUIModel?.profileImage {
                    profileImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay {
                            Text(feedUIModel.profileUIModel?.username.first?.uppercased() ?? "")
                        }
                        .frame(width: 50, height: 50)
                }
                
                VStack(alignment: .leading,spacing: 5) {
                    Text(feedUIModel.profileUIModel?.username ?? "")
                        .font(.title3)
                        
                    Text(feedUIModel.createAt)
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .bold()
                
                Spacer()
            }
            .padding(.horizontal)
            
            
            // Body
            VStack {
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .fill(Color(red: 1.0, green: 0.85, blue: 0.7))
                    .padding(.horizontal)
                    .frame(maxHeight: 200)
                    .overlay {
                        Text(feedUIModel.content)
                            .font(.title)
                    }
            }
            .frame(height: 200)
            
            
            //Footer
            VStack(alignment: .leading,spacing: 30) {
                HStack(spacing: 30) {
                    
                    Button(action: {
                        clickLikeButton()
                    }) {
                        if feedUIModel.isLikedByCurrentProfile {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundColor(.blue)
                        } else {
                            Image(systemName: "hand.thumbsup")
                                .foregroundColor(.gray)
                        }
                    }
                    .buttonStyle(.borderless)
                    
                    if showCommentButton {
                        Button(action: {
                            clickCommentButton?()
                        }) {
                            Image(systemName: "bubble.left")
                        }
                        .buttonStyle(.borderless)
                        
                    }
                    
                    Spacer()
                }
                .font(.title2)
               
                .foregroundColor(.gray)
                
                HStack {
                    
                    Text(" \(feedUIModel.likesCount) Likes")
                        .font(Font.title3)
                        .bold()
                    
                    Spacer()
                }
                
            }
            .padding(.horizontal)
            
        }
        .frame(maxWidth: .infinity)
        
    }
    
}

#Preview {
    FeedItemView(feedUIModel: FeedUIModel.mockData[0],clickLikeButton: {},clickCommentButton: {})
}
