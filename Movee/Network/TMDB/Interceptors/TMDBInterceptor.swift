//
//  TMDBInterceptor.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation

struct TMDBInterceptor: NetworkInterceptor {
    let apiKey: String
    let language: String

    init(apiKey: String = APIKeys.tmdb, language: String = "en-US") {
        self.apiKey = apiKey
        self.language = language
    }

    func intercept(request: URLRequest) async throws -> URLRequest {
        guard let url = request.url,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }

        var queryItems = components.queryItems ?? []

        queryItems.append(contentsOf: [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: language)
        ])

        components.queryItems = queryItems

        guard let modifiedURL = components.url else {
            throw NetworkError.invalidURL
        }

        var modifiedRequest = request
        modifiedRequest.url = modifiedURL

        return modifiedRequest
    }
}
