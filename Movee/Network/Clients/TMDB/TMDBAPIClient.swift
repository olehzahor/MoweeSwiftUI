//
//  TMDBAPIClient.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import Foundation
import Combine

// MARK: - Public API
final class TMDBAPIClient {
    static let shared = TMDBAPIClient()
    
    private let apiKey = "d65446acbb59f68418c9bf8dc9347056"
    private let baseURL = "https://api.themoviedb.org/3/"
    private let language = "en-US"
    
    func fetchPopularMovies(page: Int = 1) -> AnyPublisher<PaginatedResponse<Movie>, Error> {
        return getPublisher(for: "movie/popular", parameters: ["page": page])
    }
    
    func fetchTopRatedMovies(page: Int = 1) -> AnyPublisher<PaginatedResponse<Movie>, Error> {
        return getPublisher(for: "movie/top_rated", parameters: ["page": page])
    }
    
    func fetchNowPlayingMovies(page: Int = 1) -> AnyPublisher<PaginatedResponse<Movie>, Error> {
        return getPublisher(for: "movie/now_playing", parameters: ["page": page])
    }
    
    func fetchUpcomingMovies(page: Int = 1) -> AnyPublisher<PaginatedResponse<Movie>, Error> {
        return getPublisher(for: "movie/upcoming", parameters: ["page": page])
    }

    func fetchPopularTVShows(page: Int = 1) -> AnyPublisher<PaginatedResponse<TVShow>, Error> {
        return getPublisher(for: "tv/popular", parameters: ["page": page])
    }
    
    func fetchMovieGenres() -> AnyPublisher<GenresResponse, Error> {
        return getPublisher(for: "genre/movie/list")
    }

    func fetchTVGenres() -> AnyPublisher<GenresResponse, Error> {
        return getPublisher(for: "genre/tv/list")
    }

    func fetchMovieDetails(movieID: Int) -> AnyPublisher<Movie, Error> {
        return getPublisher(for: "movie/\(movieID)")
    }

    func fetchTVShowDetails(tvShowID: Int) -> AnyPublisher<TVShow, Error> {
        return getPublisher(for: "tv/\(tvShowID)")
    }

    func fetchMovieRelated(movieID: Int, page: Int = 1) -> AnyPublisher<PaginatedResponse<Movie>, Error> {
        return getPublisher(for: "movie/\(movieID)/similar", parameters: ["page": page])
    }

    func fetchTVShowRelated(tvShowID: Int, page: Int = 1) -> AnyPublisher<PaginatedResponse<TVShow>, Error> {
        return getPublisher(for: "tv/\(tvShowID)/similar", parameters: ["page": page])
    }

    func fetchMovieRecommendations(movieID: Int, page: Int = 1) -> AnyPublisher<PaginatedResponse<Movie>, Error> {
        return getPublisher(for: "movie/\(movieID)/recommendations", parameters: ["page": page])
    }

    func fetchTVShowRecommendations(tvShowID: Int, page: Int = 1) -> AnyPublisher<PaginatedResponse<TVShow>, Error> {
        return getPublisher(for: "tv/\(tvShowID)/recommendations", parameters: ["page": page])
    }

    func fetchMovieCredits(movieID: Int) -> AnyPublisher<CreditsResponse, Error> {
        return getPublisher(for: "movie/\(movieID)/credits")
    }

    func fetchTVShowCredits(tvShowID: Int) -> AnyPublisher<CreditsResponse, Error> {
        return getPublisher(for: "tv/\(tvShowID)/credits")
    }
    
    func fetchMovieReviews(movieID: Int, page: Int = 1) -> AnyPublisher<PaginatedResponse<Review>, Error> {
        return getPublisher(for: "movie/\(movieID)/reviews", parameters: ["page": page])
    }

    func fetchTVShowReviews(tvShowID: Int, page: Int = 1) -> AnyPublisher<PaginatedResponse<Review>, Error> {
        return getPublisher(for: "tv/\(tvShowID)/reviews", parameters: ["page": page])
    }

    func fetchPersonDetails(personID: Int) -> AnyPublisher<Person, Error> {
        return getPublisher(for: "person/\(personID)")
    }

    func fetchPersonCredits(personID: Int) -> AnyPublisher<PersonCombinedCreditsResponse, Error> {
        return getPublisher(for: "person/\(personID)/combined_credits")
    }

    func fetchTVShowSeason(tvShowID: Int, seasonNumber: Int) -> AnyPublisher<Season, Error> {
        return getPublisher(for: "tv/\(tvShowID)/season/\(seasonNumber)")
    }
    
    func searchMulti(query: String, page: Int = 1, includeAdult: Bool = false) -> AnyPublisher<PaginatedResponse<SearchResult>, Error> {
        return getPublisher(for: "search/multi", parameters: ["query": query, "page": page, "include_adult": includeAdult])
    }

    func fetchCollection(collectionID: Int) -> AnyPublisher<CollectionResponse, Error> {
        return getPublisher(for: "collection/\(collectionID)")
    }
    
    func fetchMovieVideos(movieID: Int) -> AnyPublisher<VideoResponse, Error> {
        return getPublisher(for: "movie/\(movieID)/videos")
    }

    func fetchTVShowVideos(tvShowID: Int) -> AnyPublisher<VideoResponse, Error> {
        return getPublisher(for: "tv/\(tvShowID)/videos")
    }

    /// Fetches a custom paginated list from the specified endpoint with raw query string parameters.
    /// - Parameters:
    ///   - endpoint: the TMDB path (e.g., "discover/tv").
    ///   - query: the raw query string, without leading "?" (e.g., "vote_count.gte=1000&sort_by=vote_count.desc").
    ///   - page: the page number (default is 1).
    func fetchCustomList<T: Decodable>(
        endpoint: String,
        query: String,
        page: Int = 1
    ) -> AnyPublisher<PaginatedResponse<T>, Error> {
        // Parse raw query string into parameters dictionary
        var parameters = [String: Any]()
        for component in query.split(separator: "&") {
            let parts = component.split(separator: "=", maxSplits: 1).map(String.init)
            if parts.count == 2 {
                parameters[parts[0]] = parts[1]
            }
        }
        parameters["page"] = page
        return getPublisher(for: endpoint, parameters: parameters)
    }
    
    private init() { }
}

// MARK: - Private methods
private extension TMDBAPIClient {
    func buildURL(for endpoint: String, parameters: [String: Any]? = nil) -> URL? {
        guard var urlComponents = URLComponents(string: baseURL + endpoint) else {
            return nil
        }
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey),
                          URLQueryItem(name: "language", value: language)]
        if let parameters = parameters {
            queryItems.append(contentsOf: parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") })
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    func getPublisher<T: Decodable>(for endpoint: String, method: HTTPMethod = .get, parameters: [String: Any]? = nil) -> AnyPublisher<T, Error> {
        guard let url = buildURL(for: endpoint, parameters: parameters) else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        return NetworkManager.shared.request(url: url, method: method, parameters: nil)
            .eraseToAnyPublisher()
    }
}
