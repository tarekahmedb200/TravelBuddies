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
    
    enum CodingKeys:  String,CodingKey {
        case id
        case username
        case description
        case address
    }
    
}


