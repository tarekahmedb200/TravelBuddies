//
//  FeedCommentInputView.swift
//  TavelsBuddies
//
//  Created by tarek on 26/09/2025.
//

import SwiftUI

struct FeedCommentInputView: View {
    
    @Binding var feedComment: String
    @Binding var profileUIModel: ProfileUIModel?
    var postComment: () -> Void
    
    @FocusState private var isTextFieldFocused: Bool
    
    private let cornerRadius: CGFloat = 10
    
    var body: some View {
        containerBackground
            .overlay {
                HStack(spacing: 12) {
                    avatar
                    commentTextField
                    postButton
                }
                .padding(.horizontal)
            }
    }
}

private extension FeedCommentInputView {
    // Background with stroke
    var containerBackground: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color(.white))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color(.lightGray), lineWidth: 0.3)
            )
    }
    
    // Avatar UI component
    var avatar: some View {
        Group {
            if let image = profileUIModel?.profileImage {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay {
                        Text(profileUIModel?.username.first.map { String($0).uppercased() } ?? "")
                            .font(.subheadline)
                            .foregroundStyle(.primary)
                    }
            }
        }
        .clipShape(Circle())
        .frame(width: 35, height: 35)
    }
    
    // TextField UI component
    var commentTextField: some View {
        TextField("Write a comment..", text: $feedComment)
            .textFieldStyle(BorderedTextFieldStyle(minHeight: 40))
            .font(.headline)
            .focused($isTextFieldFocused)
    }
    
    // Button UI component
    var postButton: some View {
        Button("Post") {
            isTextFieldFocused = false
            postComment()
        }
        .padding(.trailing)
    }
}

#Preview {
    FeedCommentInputView(
        feedComment: .constant("hello"),
        profileUIModel: .constant(ProfileUIModel.mockData[0]),
        postComment: {}
    )
}
