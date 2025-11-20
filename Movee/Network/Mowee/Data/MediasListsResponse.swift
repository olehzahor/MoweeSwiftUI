//
//  MediasListsResponse.swift
//  Movee
//
//  Created by user on 11/10/25.
//

struct MediasListsResponse: Decodable {
    let discoverLists: [MediasList]
    let homeLists: [MediasList]
}
