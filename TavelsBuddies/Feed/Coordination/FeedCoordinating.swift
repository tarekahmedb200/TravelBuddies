//
//  FeedCoordinating.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation
import SwiftUI

protocol FeedCoordinating : NavigationCoordinating , FullScreenCoordinating {
    func navigate(to page:NavigationFeedPages) -> NavigatedCustomView
    func push(to page: NavigationFeedPages)
    func popToRoot()
    
    func presentFullScreenCover(_ page: FullScreenFeedPages)
    func dismissFullScreenCover()
    func showFullScreenCover(_ page: FullScreenFeedPages) -> FullScreenCustomView
}
