//
//  MoweeEndpoint.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import Foundation

protocol MoweeEndpoint: Endpoint {}

extension MoweeEndpoint {
    var baseURL: String {
        "https://mowee.pages.dev/"
    }

    var interceptors: [NetworkInterceptor] {
        MoweeInfrastructure.interceptors
    }

    var decoder: DataDecoder {
        MoweeInfrastructure.decoder
    }
}

struct MoweeInfrastructure {
    static let interceptors: [NetworkInterceptor] = [
        LoggingInterceptor(logger: Logger.shared)
    ]

    static let decoder: DataDecoder = JSONDecoder()
}
