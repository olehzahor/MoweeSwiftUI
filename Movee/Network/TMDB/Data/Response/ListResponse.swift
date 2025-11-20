//
//  ListResponse2.swift
//  Movee
//
//  Created by user on 11/10/25.
//

struct ListResponse: Decodable {
    let createdBy: String?
    let description: String?
    let favoriteCount: Int?
    let id: Int
    let items: [Media]
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

extension ListResponse {
    var paginatedResponse: PaginatedResponse<Media> {
        .init(page: page, results: items, total_pages: totalPages, total_results: totalResults)
    }
}
