//
//  TripFilter.swift
//  TavelsBuddies
//
//  Created by tarek on 02/10/2025.
//

import Foundation

struct TripFilter {
    var location: String?
    var dateRange: ClosedRange<Date>?
    var tags: [String]?
    var priceRange: ClosedRange<Double>?
    var isFree: Bool?
}
