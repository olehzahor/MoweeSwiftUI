//
//  PersonDetailsRepository.swift
//  Movee
//
//  Created by Oleh on 05.11.2025.
//

import Factory

protocol PersonDetailsRepositoryProtocol {
    func fetchDetails(personID: Int) async throws -> MediaPerson
    func fetchKnownFor(personID: Int) async throws -> [Media]
}

struct PersonDetailsRepository: PersonDetailsRepositoryProtocol {
    private let network: NetworkClient
    private let parser: PersonDetailsRepositoryParserProtocol
    
    func fetchDetails(personID: Int) async throws -> MediaPerson {
        let person = try await network.request(TMDB.PersonDetails(personID: personID))
        return MediaPerson(person: person)
    }
    
    func fetchKnownFor(personID: Int) async throws -> [Media] {
        let response = try await network.request(TMDB.PersonCredits(personID: personID))
        return parser.parse(response)
    }
    
    init(network: NetworkClient = Container.shared.networkClient(),
         parser: PersonDetailsRepositoryParserProtocol = PersonDetailsRepositoryParser()) {
        self.network = network
        self.parser = parser
    }
}
