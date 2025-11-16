//
//  CustomList.swift
//  Movee
//
//  Created by user on 11/10/25.
//

import Foundation

extension TMDB {
    struct CustomList<T: Decodable>: TMDBEndpoint {
        typealias Response = PaginatedResponse<T>

        let page: Int

        let path: String
        let query: String?

        var method: HTTPMethod2 {
            .get
        }

        var queryItems: [URLQueryItem]? {
            (query ?? "").parseQueryString() +
            [URLQueryItem(name: "page", value: "\(page)")]
        }
        
        init(page: Int, path: String, query: String?) {
            self.page = page
            self.path = path
            self.query = query
        }
    }
}
