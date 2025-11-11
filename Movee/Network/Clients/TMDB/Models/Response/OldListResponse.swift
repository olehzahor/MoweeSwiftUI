//
//  ListResponse.swift
//  Movee
//
//  Created by user on 5/9/25.
//

import Foundation

/// Response model for the TMDB /list/{list_id} endpoint.
struct OldListResponse: Decodable {
    let createdBy: String?
    let description: String?
    let favoriteCount: Int?
    let id: Int
    let items: [SearchResult]
    let itemCount: Int?
    let iso639_1: String?
    let name: String
    let posterPath: String?
    let page: Int
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case createdBy     = "created_by"
        case description
        case favoriteCount = "favorite_count"
        case id, items
        case itemCount     = "item_count"
        case iso639_1
        case name
        case posterPath    = "poster_path"
        case page
        case totalPages    = "total_pages"
        case totalResults  = "total_results"
    }
}

extension OldListResponse {
    var paginatedResponse: PaginatedResponse<SearchResult> {
        .init(page: page, results: items, total_pages: totalPages, total_results: totalResults)
    }
}
