//
//  UserAuthenticationInfoCacheService.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation

protocol UserAuthenticationInfoCacheService {
    func saveUserAuthenticationInfo(userAuthenticationInfoPersistanceDto : UserAuthenticationInfoPersistanceDto)
    func getUserAuthenticationInfo() -> UserAuthenticationInfoPersistanceDto?
    func deleteUserAuthenticationInfo()
}
