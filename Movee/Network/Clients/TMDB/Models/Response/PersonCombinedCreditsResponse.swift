//
//  PersonCombinedCreditsResponse.swift
//  Movee
//
//  Created by user on 4/29/25.
//


// MARK: - Person Combined Credits

/// Response model for combined movie and TV credits of a person.
struct PersonCombinedCreditsResponse: Codable {
    let cast: [Media]
    let crew: [Media]
}
