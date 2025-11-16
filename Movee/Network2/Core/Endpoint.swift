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
    var parameters: [String: Any]? { get } // For GET: query params, For POST/PUT: simple JSON body
    var queryItems: [URLQueryItem]? { get } // Optional: for explicit query items (merged with parameters for GETs)
    var body: Encodable? { get } // For POST/PUT: type-safe complex body (takes priority over parameters)

    var interceptors: [NetworkInterceptor] { get }
    var decoder: DataDecoder { get }
}

extension Endpoint {
    var headers: [String: String]? { nil }
    var parameters: [String: Any]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: Encodable? { nil }

    var interceptors: [NetworkInterceptor] { [] }
    var decoder: DataDecoder { JSONDecoder() }
}
    
extension Endpoint {
    func asURLRequest() throws -> URLRequest {
        let fullURL = buildFullURL(baseURL: baseURL, path: path)

        guard var components = URLComponents(string: fullURL) else {
            throw NetworkError2.invalidURL
        }

        var allQueryItems: [URLQueryItem] = []

        if let queryItems = queryItems, !queryItems.isEmpty {
            allQueryItems.append(contentsOf: queryItems)
        }

        if method == .get, let parameters = parameters {
            let parametersAsQueryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            allQueryItems.append(contentsOf: parametersAsQueryItems)
        }

        if !allQueryItems.isEmpty {
            components.queryItems = allQueryItems
        }

        guard let url = components.url else {
            throw NetworkError2.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        if method != .get {
            if let body = body {
                request.httpBody = try JSONEncoder().encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } else if let parameters = parameters {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }

        return request
    }

    private func buildFullURL(baseURL: String, path: String) -> String {
        let trimmedBase = baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL
        let normalizedPath = path.hasPrefix("/") ? path : "/" + path
        return trimmedBase + normalizedPath
    }
}
