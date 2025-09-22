//
//  UserDefaultsCacheServiceImplementation.swift
//  TavelsBuddies
//
//  Created by tarek on 18/09/2025.
//

import Foundation


class UserDefaultsCacheService: UserAuthenticationInfoCacheService {
    
    private let userAuthKey = "user_authentication_info"
    
    func saveUserAuthenticationInfo(userAuthenticationInfoPersistanceDto: UserAuthenticationInfoPersistanceDto) {
        do {
            let data = try JSONEncoder().encode(userAuthenticationInfoPersistanceDto)
            UserDefaults.standard.set(data, forKey: userAuthKey)
        } catch {
            print("Failed to save user authentication info: \(error)")
        }
    }
    
    func getUserAuthenticationInfo() -> UserAuthenticationInfoPersistanceDto? {
        guard let data = UserDefaults.standard.data(forKey: userAuthKey) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(UserAuthenticationInfoPersistanceDto.self, from: data)
        } catch {
            print("Failed to decode user authentication info: \(error)")
            return nil
        }
    }
    
    func deleteUserAuthenticationInfo() {
        UserDefaults.standard.removeObject(forKey: userAuthKey)
    }
}
