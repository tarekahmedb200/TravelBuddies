//
//  ProfileCoordinating.swift
//  TavelsBuddies
//
//  Created by tarek on 08/10/2025.
//

import Foundation
import SwiftUI

protocol ProfileCoordinating : NavigationCoordinating  {
    func navigate(to page:NavigationProfilePages) -> NavigatedCustomView
    func push(to page: NavigationProfilePages)
    func popToRoot()
}
