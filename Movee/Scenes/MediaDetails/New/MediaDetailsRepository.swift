//
//  MediaDetailsRepository.swift
//  Movee
//
//  Created by Oleh on 21.10.2025.
//

import Foundation

protocol MediasSectionDataProvider {
    associatedtype Output: Decodable
    func fetch(page: Int) async throws -> PaginatedResponse<Output>
}

struct RelatedMediasSectionDataProvider: MediasSectionDataProvider {
    func fetch(page: Int) async throws -> PaginatedResponse<Media> {
        
    }
}

struct MediaDetailsRepository: MediaDetailsRepositoryProtocol {
    private let networkClient = NetworkClient2(
        interceptors: [
            TMDBInterceptor(),
            LoggingInterceptor(logger: Logger.shared)
        ],
        decoder: TMDBJSONDecoder()
    )
    
    func fetchMedia(_ identifier: MediaIdentifier) async throws -> Media {
        switch identifier.type {
        case .movie:
            Media(movie: try await networkClient.request(TMDB.MovieDetails(movieID: identifier.id)))
        case .tvShow:
            Media(tvShow: try await networkClient.request(TMDB.TVShowDetails(tvShowID: identifier.id)))
        }
    }
    
    func fetchRelated(_ identifier: MediaIdentifier) async throws -> [Media] {
        switch identifier.type {
        case .movie:
            let request = TMDB.MovieRecommendations(movieID: identifier.id, page: 1)
            return try await networkClient.request(request).results.map { Media(movie: $0) }
        case .tvShow:
            let request = TMDB.TVShowRecommendations(tvShowID: identifier.id, page: 1)
            return try await networkClient.request(request).results.map { Media(tvShow: $0) }
        }
    }
    
    private func parseCreditsResponse(_ response: CreditsResponse) -> [MediaPerson] {
        let cast = response.cast.map({ MediaPerson(castMember: $0) })
        let crew = response.crew.map({ MediaPerson(crewMember: $0) })
        var credits = cast + crew
        credits.sort { $0.order ?? .max <= $1.order ?? .max }
        if let index = credits.firstIndex(where: { $0.role == "Director" }) {
            credits.insert(credits.remove(at: index), at: 0)
        }
        return credits
    }
    
    func fetchCredits(_ identifier: MediaIdentifier) async throws -> [MediaPerson] {
        let response = switch identifier.type {
        case .movie:
            try await networkClient.request(TMDB.MovieCredits(movieID: identifier.id))
        case .tvShow:
            try await networkClient.request(TMDB.TVShowCredits(tvShowID: identifier.id))
        }
        return parseCreditsResponse(response)
    }
    
    func fetchReviews(_ identifier: MediaIdentifier) async throws -> [Review] {
        let response = switch identifier.type {
        case .movie:
            try await networkClient.request(TMDB.MovieReviews(movieID: identifier.id, page: 1))
        case .tvShow:
            try await networkClient.request(TMDB.TVShowReviews(tvShowID: identifier.id, page: 1))
        }
        return response.results
    }
    
    func fetchVideos(_ identifier: MediaIdentifier) async throws -> [Video] {
        let response = switch identifier.type {
        case .movie:
            try await networkClient.request(TMDB.MovieVideos(movieID: identifier.id))
        case .tvShow:
            try await networkClient.request(TMDB.TVShowVideos(tvShowID: identifier.id))
        }
        return response.results
    }
    
    func fetchCollection(_ media: Media?) async throws -> MediasCollection? {
        guard let media, case .movie(let extra) = media.extra,
              let collection = extra.belongsToCollection
        else { return nil }
        let response = try await networkClient
            .request(TMDB.Collection(id: collection.id))
        let medias = response.parts.map { Media(movie: $0) }
        return MediasCollection(name: response.name, medias: medias)
    }
}
