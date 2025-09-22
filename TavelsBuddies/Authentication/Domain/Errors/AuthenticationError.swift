//
//  AuthenticationError.swift
//  TavelsBuddies
//
//  Created by tarek on 19/09/2025.
//

import Foundation

enum AuthenticationError: Error {
    case emptyUsername
    case emptyPassword
    case unKnownError
}
