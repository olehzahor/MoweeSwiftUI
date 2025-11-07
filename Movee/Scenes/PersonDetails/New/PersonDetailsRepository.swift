//
//  PersonDetailsRepository.swift
//  Movee
//
//  Created by Oleh on 05.11.2025.
//


import SwiftUI
import Combine

protocol PersonDetailsRepositoryProtocol {
    func fetchDetails(personID: Int) async throws -> MediaPerson
    func fetchKnownFor(personID: Int) async throws -> [Media]
}

struct PersonDetailsRepository: PersonDetailsRepositoryProtocol {
    private let network: NetworkClient2 = Dependencies.networkClient
    private let parser: PersonDetailsRepositoryParserProtocol = PersonDetailsRepositoryParser()
    
    func fetchDetails(personID: Int) async throws -> MediaPerson {
        try await Task.sleep(for: .seconds(3))
        let person = try await network.request(TMDB.PersonDetails(personID: personID))
        return MediaPerson(person: person)
    }
    
    func fetchKnownFor(personID: Int) async throws -> [Media] {
        //try await Task.sleep(for: .seconds(3))
        let response = try await network.request(TMDB.PersonCredits(personID: personID))
        return parser.parse(response)
    }
}
