//
//  List.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import Foundation

extension TMDB {
    struct List: TMDBEndpoint {        
        typealias Response = ListResponse

        let page: Int
        let listID: Int
        
        var path: String {
            "list/\(listID)"
        }

        var method: HTTPMethod2 {
            .get
        }

        var queryItems: [URLQueryItem]? {
            [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
}
