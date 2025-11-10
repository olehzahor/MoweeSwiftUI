//
//  Lists.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import Foundation

extension Mowee {
    struct Lists: MoweeEndpoint {
        typealias Response = MediasListsResponse

        var path: String {
            "/explore.json"
        }

        var method: HTTPMethod2 {
            .get
        }
    }
}
