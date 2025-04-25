//
//  PopularMoviesResponse.swift
//  Movee
//
//  Created by user on 4/5/25.
//

import Foundation

struct PaginatedResponse<T: Decodable>: Decodable {
    let page: Int
    let results: [T]
    let total_pages: Int
    let total_results: Int
}

extension PaginatedResponse {
    func map<U: Decodable>(_ transform: (T) -> U) -> PaginatedResponse<U> {
        return PaginatedResponse<U>(
            page: self.page,
            results: self.results.map(transform),
            total_pages: self.total_pages,
            total_results: self.total_results
        )
    }
}
