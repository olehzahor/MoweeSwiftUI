//
//  TMDBEndpoint.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation

protocol TMDBEndpoint: Endpoint {}

extension TMDBEndpoint {
    var baseURL: String {
        "https://api.themoviedb.org/3"
    }
}
