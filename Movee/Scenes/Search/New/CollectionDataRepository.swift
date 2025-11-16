//
//  CollectionDataRepositoryProtocol.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import Foundation
import Factory

protocol CollectionDataRepository {
    func fetchLists() async throws -> [MediasList]
}

struct DiscoverCollectionDataRepository: CollectionDataRepository {
    private let network: NetworkClient2

    init(network: NetworkClient2 = Container.shared.networkClient()) {
        self.network = network
    }

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
