//
//  CollectionDataRepositoryProtocol.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import Foundation
import Factory

protocol CollectionDataRepository {
    func fetchLists() async throws -> [CollectionList]
}

struct DiscoverCollectionDataRepository: CollectionDataRepository {
    private let network: NetworkClient

    init(network: NetworkClient = Container.shared.networkClient()) {
        self.network = network
    }

    func fetchLists() async throws -> [CollectionList] {
        try await network.request(Mowee.Lists()).discoverLists
    }
}

struct StaticCollectionDataRepository: CollectionDataRepository {
    let lists: [CollectionList]
    
    func fetchLists() async throws -> [CollectionList] {
        lists
    }
}
