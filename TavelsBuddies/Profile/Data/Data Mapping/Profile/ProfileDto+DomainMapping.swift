//
//  ProfileDto+DomainMapping.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation

extension ProfileDto {
    func toDomain() -> Profile {
        Profile(id: id, username: username, description: description, address: address,gender: gender,mobileNumber: mobileNumber, countryCodeNumber: countryCodeNumber,country: country,birthDate: birthDate)
    }
}
