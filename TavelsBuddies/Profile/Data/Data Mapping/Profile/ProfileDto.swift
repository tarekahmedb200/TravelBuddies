//
//  ProfileDto.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation


struct ProfileDto: Codable {
    var id: UUID?
    var username: String
    var description: String?
    var address: String
    var gender: Gender
    var mobileNumber: String
    var countryCodeNumber: String
    var country: String
    var birthDate: Date
    
    enum CodingKeys: String,CodingKey {
        case id
        case username
        case description
        case address
        case gender
        case mobileNumber = "mobile_number"
        case countryCodeNumber = "country_code_number"
        case country
        case birthDate = "birth_date"
    }
    
}




