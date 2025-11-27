//
//  ProductionCountry.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import Foundation

struct ProductionCountry: Codable, Hashable {
    let iso3166_1: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}
