//
//  Lists.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import Foundation

extension Mowee {
    struct Lists: MoweeEndpoint {
        typealias Response = CollectionListsResponse

        var path: String {
            "explore.json"
        }

        var method: HTTPMethod {
            .get
        }
    }
}
