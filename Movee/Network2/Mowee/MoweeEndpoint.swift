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
        "https://mowee.pages.dev"
    }
}
