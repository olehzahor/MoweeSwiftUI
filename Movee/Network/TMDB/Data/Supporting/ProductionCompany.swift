//
//  ProductionCompany.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import Foundation

struct ProductionCompany: Codable, Hashable, Identifiable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}
