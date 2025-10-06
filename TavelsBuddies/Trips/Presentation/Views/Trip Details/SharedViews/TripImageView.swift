//
//  TripImageView.swift
//  TavelsBuddies
//
//  Created by tarek on 04/10/2025.
//

import SwiftUI

struct TripImageView: View {
    let tripUIModel: TripUIModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            if let tripImage = tripUIModel.tripImage {
                tripImage
                    .resizable()
                    .clipped()
                
                Text(tripUIModel.price, format: .currency(code: "USD"))
                    .font(.subheadline)
                    .bold()
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .padding(8)
            } else {
                Image("GRImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
            
        }
    }
}

#Preview {
    TripImageView(tripUIModel: TripUIModel.mockTrips[0])
}
