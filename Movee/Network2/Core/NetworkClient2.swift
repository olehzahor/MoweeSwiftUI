//
//  NetworkClient2.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation

final class NetworkClient2 {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

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

    private func applyErrorInterceptors(_ interceptors: [NetworkInterceptor], error: Error, request: URLRequest) async throws {
        for interceptor in interceptors {
            try await interceptor.intercept(error: error, request: request)
        }
    }

    private func validateResponse(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200...299:
            return

        case 401:
            throw NetworkError2.unauthorized

        case 500...599:
            throw NetworkError2.serverError

        default:
            throw NetworkError2.httpError(statusCode: response.statusCode, data: data)
        }
    }

    private func performRequest<E: Endpoint>(_ endpoint: E) async throws -> (Data, HTTPURLResponse) {
        let urlRequest = try endpoint.asURLRequest()
        let interceptedRequest = try await applyRequestInterceptors(endpoint.interceptors, to: urlRequest)

        do {
            let (data, response) = try await session.data(for: interceptedRequest)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError2.networkError(URLError(.badServerResponse))
            }

            try validateResponse(httpResponse, data: data)

            let interceptedData = try await applyResponseInterceptors(endpoint.interceptors, response: httpResponse, data: data)

            return (interceptedData, httpResponse)
        } catch {
            try await applyErrorInterceptors(endpoint.interceptors, error: error, request: interceptedRequest)
            throw error
        }
    }

    // MARK: - Public Request Methods
    @discardableResult
    func request<E: Endpoint>(_ endpoint: E) async throws -> E.Response {
        let (data, _) = try await performRequest(endpoint)

        guard !data.isEmpty else {
            throw NetworkError2.noData
        }

        do {
            return try endpoint.decoder.decode(E.Response.self, from: data)
        } catch {
            throw NetworkError2.decodingError(error)
        }
    }

//    func request<E: Endpoint>(_ endpoint: E) async throws -> Data {
//        let (data, _) = try await performRequest(endpoint)
//        return data
//    }
//
//    func request<E: Endpoint>(_ endpoint: E) async throws {
//        _ = try await performRequest(endpoint)
//    }
}
