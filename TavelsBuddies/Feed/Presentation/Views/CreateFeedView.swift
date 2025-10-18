//
//  CreateFeedView.swift
//  TavelsBuddies
//
//  Created by tarek on 24/09/2025.
//

import SwiftUI
import PhotosUI

struct CreateFeedView: View {
    
    @StateObject var viewModel: CreateFeedViewModel
    @State private var selectedPhotoItems: [PhotosPickerItem] = []
    @State private var maxNumbers: Int = 3
    
    var body: some View {
        NavigationStack {
            ScrollView {
                //Header
                HStack(alignment: .center, spacing: 20) {
                    
                    if let profileImage = viewModel.profileUIModel?.profileImage {
                        profileImage
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .border(Color.black, width: 0.5)
                    } else {
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
                
                //Body - Media Display Area
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.feedMediaDataUIModels) { media in
                            if let feedImage = media.feedImage {
                                FeedImageItemView(image: feedImage) {
                                    viewModel.removeImage(feedMediaDataUIModel: media)
                                }
                            }
                        }
                        
                        PhotosPicker(selection: $selectedPhotoItems, maxSelectionCount: maxNumbers - viewModel.feedMediaDataUIModels.count, matching: .images, label: {
                            VStack(spacing: 8) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                                Text("Add More")
                                    .font(.caption)
                            }
                            .foregroundStyle(Color.blue)
                            .frame(width: 120, height: 120)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        })
                        .disabled(viewModel.feedMediaDataUIModels.count == maxNumbers)
                        
                    }
                    .padding()
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
            .onChange(of: selectedPhotoItems) { oldValue, newValue in
                handlePhotoSelection(newValue)
            }
            
        }
    }
    
    private func handlePhotoSelection(_ photoItems: [PhotosPickerItem]) {
        Task {
            for photoItem in photoItems {
                do {
                    if let data = try await photoItem.loadTransferable(type: Data.self) {
                        let uuid = UUID()
                        viewModel.addImage(itemID: uuid, imageData: data)
                    }
                } catch {
                    print("Error loading photo: \(error)")
                }
            }
            
            selectedPhotoItems = []
        }
    }
    
    private func removePhoto(_ media: FeedMediaMetaDataUIModel) {
        viewModel.removeImage(feedMediaDataUIModel: media)
    }
}

#Preview {
    NavigationStack {
        CreateFeedView(viewModel: CreateFeedFactory(coordinator: FeedCoordinator()).getCreateFeedViewModel())
    }
}
