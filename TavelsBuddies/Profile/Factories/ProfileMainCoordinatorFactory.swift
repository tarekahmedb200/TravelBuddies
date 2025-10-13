//
//  ProfileMainCoordinatorFactory.swift
//  TavelsBuddies
//
//  Created by tarek on 09/10/2025.
//

import Foundation
import SwiftUI
import Combine


class ProfileMainCoordinatorFactory {
    var firstPage: NavigationProfilePages
    @Published var path : NavigationPath?
    
    init(firstPage: NavigationProfilePages, path: NavigationPath? = nil) {
        self.firstPage = firstPage
        self.path = path
    }
    
    func getProfileCoordinationView() -> ProfileCoordinationView {
        if let path = path {
            ProfileCoordinationView(firstPage: firstPage, isEmbed: false, coordinator: ProfileCoordinator(path: path))
        }else {
            ProfileCoordinationView(firstPage: firstPage, isEmbed: true, coordinator: ProfileCoordinator())
        }
    }
}
