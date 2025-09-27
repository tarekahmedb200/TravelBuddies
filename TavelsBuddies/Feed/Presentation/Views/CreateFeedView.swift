//
//  CreateFeedView.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import SwiftUI

struct CreateFeedView: View {
    
    @StateObject var viewModel: CreateFeedViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                //Header
                HStack(alignment: .center,spacing: 20) {
                    
                    if let profileImage = viewModel.profileUIModel?.profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .border(Color.black, width: 0.5)
                    }else {
                        Circle()
                            .fill(Color.gray)
                            .stroke(Color.black, lineWidth: 0.5)
                            .overlay {
                                Text(viewModel.profileUIModel?.username.first?.uppercased() ?? "")
                            }
                            .frame(width: 50, height: 50)
                    }
                    
                    Text(viewModel.profileUIModel?.username ?? "")
                        .font(.title)
                    
                    Spacer()
                }
                
                //Body
                RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                    .padding()
                    .overlay {
                        Button {
                            
                        } label: {
                            VStack(spacing: 10) {
                                Image(systemName: "camera.fill")
                                    .font(.title)
                                Text("Add Media")
                                    .font(.title3)
                            }
                            .foregroundStyle(Color.black)
                        }
                    }
                
                
                //Footer
                TextField("Write Your Thoughts", text: $viewModel.content)
                    .textFieldStyle(BorderedTextFieldStyle(minHeight: 100))
                
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.createFeed()
                    }) {
                        Text("Post")
                            .font(.callout)
                            .foregroundStyle(Color.white)
                    }
                    .padding()
                    .background(Color.blue)
                }
            }
            .onAppear {
                viewModel.getCurrentProfile()
            }
            
            
        }
    }
}

#Preview {
    NavigationStack {
        CreateFeedView(viewModel: CreateFeedFactory(coordinator: FeedCoordinator()).getCreateFeedViewModel())
    }
}
