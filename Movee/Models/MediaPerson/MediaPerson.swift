//
//  MediaPerson.swift
//  Movee
//
//  Created by user on 4/11/25.
//

import Foundation
import UIKit

struct MediaPerson: Hashable, Identifiable {
    let id: Int
    let type: PersonType
    let name: String
    let profilePath: String?
    let role: String?
    let department: String?
    let popularity: Double?

    let creditID: String?
    let gender: Int?

    let castID: Int?
    let order: Int?

    // Detailed person info from TMDB
    let birthday: String?
    let deathday: String?
    let biography: String?
    let placeOfBirth: String?
    let adult: Bool?
    let imdbID: String?
    let homepage: String?
    let alsoKnownAs: [String]?
    let knownFor: [PersonCredit]?
    
    init(id: Int, type: PersonType, name: String, profilePath: String? = nil, role: String? = nil, department: String? = nil, popularity: Double? = nil, creditID: String? = nil, gender: Int? = nil, castID: Int? = nil, order: Int? = nil, birthday: String? = nil, deathday: String? = nil, biography: String? = nil, placeOfBirth: String? = nil, adult: Bool? = nil, imdbID: String? = nil, homepage: String? = nil, alsoKnownAs: [String]? = nil, knownFor: [PersonCredit]? = nil) {
        self.id = id
        self.type = type
        self.name = name
        self.profilePath = profilePath
        self.role = role
        self.department = department
        self.popularity = popularity
        self.creditID = creditID
        self.gender = gender
        self.castID = castID
        self.order = order
        self.birthday = birthday
        self.deathday = deathday
        self.biography = biography
        self.placeOfBirth = placeOfBirth
        self.adult = adult
        self.imdbID = imdbID
        self.homepage = homepage
        self.alsoKnownAs = alsoKnownAs
        self.knownFor = knownFor
    }
}

extension MediaPerson {
    enum PersonType {
        case cast, crew, unknown

        var title: String {
            switch self {
            case .cast:
                return "Cast"
            case .crew:
                return "Crew"
            case .unknown:
                return "Unknown"
            }
        }
    }
}
