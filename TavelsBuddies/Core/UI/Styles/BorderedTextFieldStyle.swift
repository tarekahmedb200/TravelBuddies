//
//  BorderedTextFieldStyle.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation
import SwiftUI


struct BorderedTextFieldStyle: TextFieldStyle {
    
    var minHeight: CGFloat = 50
    
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(10)
            .frame(minHeight: minHeight, alignment: .topLeading)
            .background(Color.white) // optional
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
            )
    }
}
