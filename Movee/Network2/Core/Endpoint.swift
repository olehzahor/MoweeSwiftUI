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
}

extension Endpoint {
    var headers: [String: String]? { nil }
    var parameters: [String: Any]? { nil }
    var queryItems: [URLQueryItem]? { nil }
}
    
extension Endpoint {
    func asURLRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
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
}
