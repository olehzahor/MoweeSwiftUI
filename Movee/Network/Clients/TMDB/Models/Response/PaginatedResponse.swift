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
    static func wrap<U: Decodable>(_ value: [U]) -> PaginatedResponse<U> {
        return PaginatedResponse<U>(
            page: 1,
            results: value,
            total_pages: 1,
            total_results: 1
        )
    }
    
    func map<U: Decodable>(_ transform: (T) -> U) -> PaginatedResponse<U> {
        return PaginatedResponse<U>(
            page: self.page,
            results: self.results.map(transform),
            total_pages: self.total_pages,
            total_results: self.total_results
        )
    }
    
    func compactMap<U: Decodable>(_ transform: (T) -> U?) -> PaginatedResponse<U> {
        return PaginatedResponse<U>(
            page: self.page,
            results: self.results.compactMap(transform),
            total_pages: self.total_pages,
            total_results: self.total_results
        )
    }
}
