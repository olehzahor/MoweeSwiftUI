//
//  Endpoint.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation

protocol Endpoint {
    associatedtype Response: Decodable

    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod2 { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var queryItems: [URLQueryItem]? { get } // TODO: improve with custom struct for convenience
    var interceptors: [NetworkInterceptor] { get }
    var decoder: DataDecoder { get }
}

extension Endpoint {
    var headers: [String: String]? { nil }
    var parameters: [String: Any]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var interceptors: [NetworkInterceptor] { [] }
    var decoder: DataDecoder { JSONDecoder() }
}
    
extension Endpoint {
    func asURLRequest() throws -> URLRequest {
        let fullURL = buildFullURL(baseURL: baseURL, path: path)

        guard var components = URLComponents(string: fullURL) else {
            throw NetworkError2.invalidURL
        }

        if let queryItems = queryItems, !queryItems.isEmpty {
            components.queryItems = queryItems
        }

        guard let url = components.url else {
            throw NetworkError2.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if method != .get, let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return request
    }

    private func buildFullURL(baseURL: String, path: String) -> String {
        let trimmedBase = baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL
        let normalizedPath = path.hasPrefix("/") ? path : "/" + path
        return trimmedBase + normalizedPath
    }
}
