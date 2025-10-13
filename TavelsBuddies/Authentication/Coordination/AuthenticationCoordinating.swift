//
//  AppCoordination.swift
//  TavelsBuddies
//
//  Created by tarek on 23/09/2025.
//

import Foundation
import SwiftUI

protocol AuthenticationCoordinating : NavigationCoordinating {
    func navigate(to page:NavigationAuthenticationPages) -> NavigatedCustomView
    func push(to page: NavigationAuthenticationPages)
    func popToRoot()
}


