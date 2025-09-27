//
//  Coordinating.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation
import SwiftUI

protocol NavigationCoordinating: AnyObject {
    associatedtype NavigationPage : Hashable
    associatedtype NavigatedCustomView : View
    
    @ViewBuilder
    func navigate(to page:NavigationPage) -> NavigatedCustomView
    func push(to page: NavigationPage)
    func popToRoot()
}
