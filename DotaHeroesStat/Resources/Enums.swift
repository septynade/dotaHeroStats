//
//  Enums.swift
//  DotaHeroesStat
//
//  Created by Ade Septian on 22/10/22.
//

import Combine
import Foundation

enum HeroRoles: String {
    case all = "All"
    case carry = "Carry"
    case support = "Support"
    case nuker = "Nuker"
    case disabler = "Disabler"
    case jungler = "Jungler"
    case durable = "Durable"
    case escape = "Escape"
    case pusher = "Pusher"
    case initiator = "Initiator"
}

enum AttackType: String {
    case melee = "Melee"
    case range = "Ranged"
}

enum primaryAttribute: String {
    case agi = "agi"
    case int = "int"
    case str = "str"
}

enum AppState {
    case idle
    case loading
    case success
    case failure(NetworkError)
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case dataTaskError
    case corruptData
    case decodingError
    case encodingError
    case limitExceeded
    case serverError
    case clientError
    case connectionError
    case emptyData
    case unknownError
    
    var errorMessage: String {
        switch self {
        case .emptyData:
            return "We couldn't find the user you're looking for"
        case .limitExceeded:
            return "Github API rate limit exceeded. Please wait for 60 seconds and try again"
        case .connectionError:
            return "Couldn't reach the server, please check your connection and try again"
        case .serverError:
            return "Shomething's wrong with the server, please try again later"
        default:
            return "Something's wrong, please try again later..."
        }
    }
}

enum AppEvent {
    case viewDidLoad
    case changeFilter(Int)
}

typealias EventOutput = AnyPublisher<AppState, Never>
