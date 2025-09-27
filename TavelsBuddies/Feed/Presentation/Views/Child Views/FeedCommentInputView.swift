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
    
    var body: some View {
        
        RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
            .fill(Color(.white))
            .stroke(Color(.lightGray), lineWidth: 0.3)
            .overlay {
                HStack(alignment: .center) {
                    
                    if let profileImage = profileUIModel?.profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                    }else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay {
                                Text(profileUIModel?.username.first?.uppercased() ?? "")
                            }
                            .frame(width: 35, height: 35)
                    }

                    TextField("Write a comment..", text: $feedComment)
                        .textFieldStyle(BorderedTextFieldStyle(minHeight: 40))
                        .font(.headline)
                        .padding()
                        .focused($isTextFieldFocused)
                    
                    Button {
                        isTextFieldFocused = false
                        postComment()
                    } label: {
                        Text("Post")
                    }
                    .padding(.trailing)
                }
                .padding(.horizontal)
            }
    }
}

#Preview {
    FeedCommentInputView(feedComment: .constant("hello"), profileUIModel:.constant( ProfileUIModel.mockData[0]), postComment: {})
}
