//
//  Color+Extension.swift
//  TavelsBuddies
//
//  Created by tarek on 04/10/2025.
//

import Foundation
import SwiftUI

extension Color {
    static var MainComponentColor: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.36, green: 0.61, blue: 0.84),
                Color(red: 0.96, green: 0.66, blue: 0.38)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

