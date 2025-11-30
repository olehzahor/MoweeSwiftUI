//
//  SpokenLanguage.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import Foundation

struct SpokenLanguage: Codable, Hashable {
    let englishName: String?
    let iso639_1: String
    let name: String?

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}
