//
//  ProfileCrudOperationError.swift
//  TavelsBuddies
//
//  Created by tarek on 20/09/2025.
//

import Foundation

enum ProfileUseCaseError: Error {
    case failedToGetUserID
    case emptyUserName
    case emptyAddress
    case emptyMobileNumber
    case emptyCountry
    case invalidBirthDate
}
