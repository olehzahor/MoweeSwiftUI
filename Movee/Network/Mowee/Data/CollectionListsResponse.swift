//
//  CollectionListsResponse.swift
//  Movee
//
//  Created by user on 11/10/25.
//

struct CollectionListsResponse: Decodable {
    let discoverLists: [CollectionList]
    let homeLists: [CollectionList]
}
