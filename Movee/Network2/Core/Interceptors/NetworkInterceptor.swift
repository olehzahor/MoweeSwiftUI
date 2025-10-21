//
//  NetworkInterceptor.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation

protocol NetworkInterceptor {
    /// Intercepts and potentially modifies an outgoing request
    func intercept(request: URLRequest) async throws -> URLRequest

    /// Intercepts and potentially modifies a successful response
    func intercept(response: HTTPURLResponse, data: Data) async throws -> Data

    /// Intercepts an error before it's thrown
    func intercept(error: Error, request: URLRequest) async throws
}

// Default implementations to make response/error methods optional
extension NetworkInterceptor {
    func intercept(response: HTTPURLResponse, data: Data) async throws -> Data {
        return data
    }

    func intercept(error: Error, request: URLRequest) async throws {
        throw error
    }
}
