//
//  NetworkClient2.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation

final class NetworkClient {
    private let session: URLSession

    // MARK: - Private Helpers
    private func applyRequestInterceptors(_ interceptors: [NetworkInterceptor], to request: URLRequest) async throws -> URLRequest {
        var modifiedRequest = request
        for interceptor in interceptors {
            modifiedRequest = try await interceptor.intercept(request: modifiedRequest)
        }
        return modifiedRequest
    }

    private func applyResponseInterceptors(_ interceptors: [NetworkInterceptor], response: HTTPURLResponse, data: Data) async throws -> Data {
        var modifiedData = data
        for interceptor in interceptors {
            modifiedData = try await interceptor.intercept(response: response, data: modifiedData)
        }
        return modifiedData
    }

    private func applyErrorInterceptors(_ interceptors: [NetworkInterceptor], error: Error, request: URLRequest) async -> Error {
        var transformedError = error
        for interceptor in interceptors {
            transformedError = await interceptor.intercept(error: transformedError, request: request)
        }
        return transformedError
    }

    private func validateResponse(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200...299:
            return

        case 401:
            throw NetworkError.unauthorized

        case 500...599:
            throw NetworkError.serverError

        default:
            throw NetworkError.httpError(statusCode: response.statusCode, data: data)
        }
    }

    private func performRequest<E: Endpoint>(_ endpoint: E) async throws -> (Data, HTTPURLResponse, URLRequest) {
        let urlRequest = try endpoint.asURLRequest()
        let interceptedRequest = try await applyRequestInterceptors(endpoint.interceptors, to: urlRequest)

        do {
            let (data, response) = try await session.data(for: interceptedRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.networkError(URLError(.badServerResponse))
            }

            try validateResponse(httpResponse, data: data)

            let interceptedData = try await applyResponseInterceptors(endpoint.interceptors, response: httpResponse, data: data)

            return (interceptedData, httpResponse, interceptedRequest)
        } catch {
            let transformedError = await applyErrorInterceptors(endpoint.interceptors, error: error, request: interceptedRequest)
            throw transformedError
        }
    }

    private func decode<E: Endpoint>(_ data: Data, using endpoint: E, request: URLRequest) async throws -> E.Response where E.Response: Decodable {
        guard !data.isEmpty else {
            throw NetworkError.noData
        }

        do {
            return try endpoint.decoder.decode(E.Response.self, from: data)
        } catch {
            let decodingError = NetworkError.decodingError(error)
            let transformedError = await applyErrorInterceptors(endpoint.interceptors, error: decodingError, request: request)
            throw transformedError
        }
    }

    // MARK: - Public Request Methods
    @discardableResult
    func request<E: Endpoint>(_ endpoint: E) async throws -> E.Response where E.Response: Decodable {
        let (data, _, request) = try await performRequest(endpoint)
        return try await decode(data, using: endpoint, request: request)
    }

    func request<E: Endpoint>(_ endpoint: E) async throws -> E.Response where E.Response == Data {
        let (data, _, _) = try await performRequest(endpoint)
        return data
    }
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}
