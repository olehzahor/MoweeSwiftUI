//
//  FetchError.swift
//  Movee
//
//  Created by user on 19.10.25.
//

import Foundation

enum FetchError: LocalizedError {
    case noConfigurationFound(section: String)

    var errorDescription: String? {
        switch self {
        case .noConfigurationFound(let section):
            return "No fetch configuration found for section: \(section)"
        }
    }
}
