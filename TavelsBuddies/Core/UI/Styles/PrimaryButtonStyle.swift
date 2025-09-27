//
//  PrimaryButtonStyle.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation
import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var cornerRadius: CGFloat = 12
    var backgroundColor: Color = .blue
    var foregroundColor: Color = .white
    var pressedColor: Color = .blue.opacity(0.7)
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(foregroundColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? pressedColor : backgroundColor)
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(duration: 0.2), value: configuration.isPressed)
            .padding(.horizontal)
    }
}
