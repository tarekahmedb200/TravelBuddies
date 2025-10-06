//
//  TripDescriptionView.swift
//  TavelsBuddies
//
//  Created by tarek on 03/10/2025.
//

import SwiftUI

struct TripDescriptionView: View {
    
    var description: String
    
    var body: some View {
        
        VStack(alignment: .leading,spacing: 20) {
            Text("About This Trip")
                .font(.title2)
                .frame(alignment: .leading)
            
            Text(description)
                .font(.title3)
                .lineSpacing(3)
                .foregroundStyle(Color(.secondaryLabel))
                .frame(alignment: .leading)
            
            Spacer()
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding()
        .bold()

    }
}

#Preview {
    TripDescriptionView(description: "")
}
