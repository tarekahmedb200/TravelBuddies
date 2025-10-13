//
//  LocaleHelper.swift
//  TavelsBuddies
//
//  Created by tarek on 12/10/2025.
//

import Foundation

final class LocaleHelper {
    
    static let shared = LocaleHelper()
    
    private init() {}
    
    var getCurrentRegionCode : String {
        return Locale.current.region?.identifier ?? "US"
    }
}
