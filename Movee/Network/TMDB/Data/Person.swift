//
//  Person.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import Foundation

struct Person: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let birthday: String?
    let department: String?
    let deathday: String?
    let biography: String?
    let popularity: Double?
    let placeOfBirth: String?
    let profilePath: String?
    let adult: Bool?
    let imdbID: String?
    let homepage: String?
    let alsoKnownAs: [String]?
    let knownFor: [PersonCredit]?
    let gender: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, birthday, deathday, biography, popularity, adult, homepage, gender
        case department = "known_for_department"
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case alsoKnownAs = "also_known_as"
        case imdbID = "imdb_id"
        case knownFor = "known_for"
    }

    init(id: Int, name: String, birthday: String? = nil, department: String? = nil, deathday: String? = nil, biography: String? = nil, popularity: Double? = nil, placeOfBirth: String? = nil, profilePath: String? = nil, adult: Bool? = nil, imdbID: String? = nil, homepage: String? = nil, alsoKnownAs: [String]? = nil, knownFor: [PersonCredit]? = nil, gender: Int? = nil) {
        self.id = id
        self.name = name
        self.birthday = birthday
        self.department = department
        self.deathday = deathday
        self.biography = biography
        self.popularity = popularity
        self.placeOfBirth = placeOfBirth
        self.profilePath = profilePath
        self.adult = adult
        self.imdbID = imdbID
        self.homepage = homepage
        self.alsoKnownAs = alsoKnownAs
        self.knownFor = knownFor
        self.gender = gender
    }
}
