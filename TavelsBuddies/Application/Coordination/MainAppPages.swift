//
//  AppPages.swift
//  TavelsBuddies
//
//  Created by tarek on 22/09/2025.
//

import Foundation

enum NavigationAppPages: Hashable {
    case signIn
    case signUp
}

enum FullScreenAppPages: Hashable , Identifiable{
    var id : UUID {
        return UUID()
    }
    
    case mainView
}
