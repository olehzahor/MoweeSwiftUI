//
//  NetworkError.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import Foundation

struct NetworkError: Error {
    let request: RequestDetails
    let response: ResponseDetails?
    let underlyingError: Error?
    
    var errorType: ErrorType {
        if let urlError = underlyingError as? URLError {
            switch urlError.code {
            case .timedOut:
                return .timeout
            case .cancelled:
                return .cancelled
            case .notConnectedToInternet:
                return .noInternet
            default:
                break
            }
        }
        if let response = response {
            if let data = response.responseBody, data.isEmpty {
                return .emptyResponse
            }
            if let status = response.statusCode, !(200...299).contains(status) {
                return .invalidResponse
            }
        }
        if let error = underlyingError, error is DecodingError {
            return .decodeError
        }
        return .underlying
    }
    
    var localizedDescription: String {
        switch errorType {
        case .emptyResponse:
            return "Empty response for \(request.method.rawValue) \(request.url.absoluteString) with parameters: \(request.parameters ?? [:])"
        case .invalidResponse:
            let bodyString = response?.responseBody.flatMap { String(data: $0, encoding: .utf8) } ?? "none"
            return "Invalid response for \(request.method.rawValue) \(request.url.absoluteString). Status code: \(response?.statusCode ?? -1), parameters: \(request.parameters ?? [:]), response body: \(bodyString)"
        case .decodeError:
            let bodyString = response?.responseBody.flatMap { String(data: $0, encoding: .utf8) } ?? "binary"
            return "Decode error for \(request.method.rawValue) \(request.url.absoluteString). Status code: \(response?.statusCode ?? -1), parameters: \(request.parameters ?? [:]), response body: \(bodyString), error: \(underlyingError?.localizedDescription ?? "unknown")"
        case .timeout:
            return "Request timed out for \(request.method.rawValue) \(request.url.absoluteString) with parameters: \(request.parameters ?? [:])."
        case .cancelled:
            return "Request was cancelled for \(request.method.rawValue) \(request.url.absoluteString) with parameters: \(request.parameters ?? [:])."
        case .noInternet:
            return "No internet connection for \(request.method.rawValue) \(request.url.absoluteString) with parameters: \(request.parameters ?? [:])."
        case .underlying:
            return "Underlying error for \(request.method.rawValue) \(request.url.absoluteString), parameters: \(request.parameters ?? [:]), error: \(underlyingError?.localizedDescription ?? "unknown")"
        }
    }
}

extension NetworkError {
    enum ErrorType {
        case emptyResponse
        case invalidResponse
        case decodeError
        case timeout
        case cancelled
        case noInternet
        case underlying
    }
    
    struct RequestDetails {
        let url: URL
        let method: HTTPMethod
        let parameters: [String: Any]?
    }
    
    struct ResponseDetails {
        let responseBody: Data?
        let statusCode: Int?
    }
}
