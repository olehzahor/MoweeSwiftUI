//
//  CollectionDataRepositoryProtocol.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import Foundation

protocol CollectionDataRepository {
    func fetchLists() async throws -> [MediasList]
}

struct DiscoverCollectionDataRepository: CollectionDataRepository {
    private let network = NetworkClient2(decoder: JSONDecoder())
    
    func fetchLists() async throws -> [MediasList] {
        try await network.request(Mowee.Lists()).discoverLists
    }
}

struct StaticCollectionDataRepository: CollectionDataRepository {
    let lists: [MediasList]
    
    func fetchLists() async throws -> [MediasList] {
        lists
    }
}
