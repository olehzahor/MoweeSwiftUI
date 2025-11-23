//
//  TMDBEndpoint.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation
import Factory

protocol TMDBEndpoint: Endpoint {}

extension TMDBEndpoint {
    var baseURL: String {
        "https://api.themoviedb.org/3/"
    }

    var interceptors: [NetworkInterceptor] {
        TMDBInfrastructure.interceptors
    }

    var decoder: DataDecoder {
        TMDBInfrastructure.decoder
    }
}

struct TMDBInfrastructure {
    static let interceptors: [NetworkInterceptor] = [
        TMDBInterceptor(),
        LoggingInterceptor(logger: Container.shared.logger(), level: .compact)
    ]

    static let decoder: DataDecoder = TMDBJSONDecoder()
}
