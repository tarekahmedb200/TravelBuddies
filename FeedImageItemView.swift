//
//  FeedImageItemView.swift
//  TavelsBuddies
//
//  Created by tarek on 17/10/2025.
//
import SwiftUI
import Foundation

struct FeedImageItemView: View {
    let image: Image
    let onRemove: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            image
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay {
                    Button(action: onRemove) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.white)
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                            .font(.title)
                    }
                }
        }
    }
}


