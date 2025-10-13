//
//  CountryCode.swift
//  TavelsBuddies
//
//  Created by tarek on 12/10/2025.
//

import Foundation

struct CountryCode: Identifiable, Hashable, Codable {
    var id : UUID {
        UUID()
    }
    
    static var allCodes : [CountryCode] = {

        do {
            guard let url = Bundle.main.url(forResource: "CountryCodes", withExtension: "json") else {
                return []
            }
            
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([CountryCode].self, from: data)
            return decoded
        } catch  {
            print(error)
            return []
        }
    }()
    
    static func getCurrentCountryCode() -> CountryCode {
        allCodes.first(where: { $0.countryCode.lowercased() == Locale.current.region?.identifier.lowercased() ?? "" }) ?? allCodes[0]
    }
    
    let country: String
    let countryCode: String   // 🇺🇸 → "US"
    let code: String          // "+1"
    let flag: String
}

