//
//  AppManager.swift
//  TavelsBuddies
//
//  Created by tarek on 12/10/2025.
//

import Foundation

import Combine

enum AppState: String {
    case isAuthenticated
    case isNotAuthenticated
}

final class AppManager: ObservableObject {
    static let shared = AppManager()
    private let key = "app_state"
    private var cancellables = Set<AnyCancellable>()

    @Published var state: AppState {
        didSet {
            UserDefaults.standard.set(state.rawValue, forKey: key)
        }
    }

    private init() {
        if let value = UserDefaults.standard.string(forKey: key),
           let savedState = AppState(rawValue: value) {
            state = savedState
        } else {
            state = .isNotAuthenticated
        }
    }

    // MARK: - State transitions
    func signIn() {
        state = .isAuthenticated
    }

    func signOut() {
        state = .isNotAuthenticated
    }
}
