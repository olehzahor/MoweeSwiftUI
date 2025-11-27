//
//  Credits.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import Foundation

// CreditsResponse: Represents the full credits response from TMDB.
struct CreditsResponse: Codable, Hashable {
    let id: Int
    let cast: [CastMember]
    let crew: [CrewMember]
}

// CastMember: Represents an individual cast member.
struct CastMember: Codable, Hashable, Identifiable {
    let id: Int
    let castID: Int?
    let character: String?
    let creditID: String?
    let gender: Int?
    let name: String
    let order: Int?
    let profilePath: String?
    let department: String?
    let popularity: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case gender, name, order
        case profilePath = "profile_path"
        case department = "known_for_department"
        case popularity
    }
}

// CrewMember: Represents an individual crew member.
struct CrewMember: Codable, Hashable, Identifiable {
    let id: Int
    let creditID: String?
    let department: String?
    let gender: Int?
    let job: String?
    let name: String
    let profilePath: String?
    let popularity: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case department, gender, job, name
        case profilePath = "profile_path"
        case popularity
    }
}
