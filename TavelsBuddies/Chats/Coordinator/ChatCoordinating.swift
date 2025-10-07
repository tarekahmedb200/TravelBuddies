//
//  ChatCoordinating.swift
//  TavelsBuddies
//
//  Created by tarek on 06/10/2025.
//

import Foundation


protocol ChatCoordinating : NavigationCoordinating , FullScreenCoordinating {
    func navigate(to page:NavigationChatPages) -> NavigatedCustomView
    func push(to page: NavigationChatPages)
    func popToRoot()
    
    func presentFullScreenCover(_ page: FullScreenChatPages)
    func dismissFullScreenCover()
    func showFullScreenCover(_ page: FullScreenChatPages) -> FullScreenCustomView
}
