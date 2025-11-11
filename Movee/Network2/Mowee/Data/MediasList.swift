//
//  MediasList.swift
//  Movee
//
//  Created by user on 11/10/25.
//

struct MediasList: Decodable, Hashable {
    enum MediaType: String, Decodable {
        case movie, tv, themedList
    }
    let localizedNames: [String: String]?
    let mediaType: MediaType?
    let name: String
    let path: String?
    let query: String?
    let nestedLists: [MediasList]?
}
