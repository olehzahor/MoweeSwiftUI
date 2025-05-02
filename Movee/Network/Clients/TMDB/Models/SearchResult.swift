//
//  SearchResult.swift
//  Movee
//
//  Created by user on 5/2/25.
//

/// A single search result which can be a Movie, TVShow, or Person.
struct SearchResult: Decodable, Identifiable, Equatable {
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id
    }
    
    enum MediaType: String, Decodable {
        case movie, tv, person
    }

    let mediaType: MediaType
    let result: Result

    var id: Int {
        switch result {
        case .movie(let movie): return movie.id
        case .tv(let tvShow): return tvShow.id
        case .person(let person): return person.id
        }
    }

    enum Result {
        case movie(Movie)
        case tv(TVShow)
        case person(Person)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mediaType = try container.decode(MediaType.self, forKey: .mediaType)
        switch mediaType {
        case .movie:
            let movie = try Movie(from: decoder)
            result = .movie(movie)
        case .tv:
            let tvShow = try TVShow(from: decoder)
            result = .tv(tvShow)
        case .person:
            let person = try Person(from: decoder)
            result = .person(person)
        }
    }

    private enum CodingKeys: String, CodingKey {
        case mediaType = "media_type"
    }
}
