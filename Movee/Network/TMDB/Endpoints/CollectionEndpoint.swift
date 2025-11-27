//
//  Collection.swift
//  Movee
//
//  Created by Oleh on 21.10.2025.
//

extension TMDB {
    struct Collection: TMDBEndpoint {
        typealias Response = CollectionResponse

        let id: Int

        var path: String {
            "collection/\(id)"
        }

        var method: HTTPMethod {
            .get
        }
    }
}
