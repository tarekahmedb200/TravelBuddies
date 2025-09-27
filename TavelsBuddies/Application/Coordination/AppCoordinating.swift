//
//  AppCoordination.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation
import SwiftUI

protocol AppCoordinating : NavigationCoordinating , FullScreenCoordinating {
    
    func navigate(to page:NavigationAppPages) -> NavigatedCustomView
    func push(to page: NavigationAppPages)
    func popToRoot()
    
    func presentFullScreenCover(_ page: FullScreenAppPages)
    func dismissFullScreenCover()
    func showFullScreenCover(_ page: FullScreenAppPages) -> FullScreenCustomView
}


