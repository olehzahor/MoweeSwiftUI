//
//  NetworkManager.swift
//  Movee
//
//  Created by user on 4/3/25.
//

import Foundation
import Combine

final class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    private let logResponse: Bool = false
    
    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        
        // ISO8601 formatter supporting fractional seconds
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        
        // Custom strategy: try fractional-second parser, else throw
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            if let date = isoFormatter.date(from: dateStr) {
                return date
            }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid ISO8601 date: \(dateStr)"
            )
        }
        
        return decoder
    }()
    
    func request<T: Decodable>(url: URL,
                               method: HTTPMethod = .get,
                               parameters: [String: Any]? = nil) -> AnyPublisher<T, Error> {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let requestDetails = NetworkError.RequestDetails(url: url, method: method, parameters: parameters)
        
        if let parameters = parameters {
            if method == .get {
                if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    let queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                    urlComponents.queryItems = queryItems
                    if let modifiedURL = urlComponents.url {
                        urlRequest.url = modifiedURL
                    }
                }
            } else {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }
            }
        }
        
        Logger.shared.log("Initiating network request to \(url.absoluteString) with method \(method.rawValue) and parameters: \(parameters ?? [:])", level: .info)
        
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response -> (Data, HTTPURLResponse) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    let responseDetails = NetworkError.ResponseDetails(responseBody: data, statusCode: nil)
                    throw NetworkError(request: requestDetails, response: responseDetails, underlyingError: nil)
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    let responseDetails = NetworkError.ResponseDetails(responseBody: data, statusCode: httpResponse.statusCode)
                    throw NetworkError(request: requestDetails, response: responseDetails, underlyingError: nil)
                }
                
                if data.isEmpty {
                    let responseDetails = NetworkError.ResponseDetails(responseBody: data, statusCode: httpResponse.statusCode)
                    throw NetworkError(request: requestDetails, response: responseDetails, underlyingError: nil)
                }
                
                Logger.shared.log("Received response for \(url.absoluteString) with status code \(httpResponse.statusCode)", level: .info)
                
                if self.logResponse {
                    if let responseString = String(data: data, encoding: .utf8) {
                        Logger.shared.log("Response body: \(responseString)", level: .info)
                    } else {
                        Logger.shared.log("Response body: <unable to decode as UTF-8>", level: .info)
                    }
                }
                
                return (data, httpResponse)
            }
            .tryMap { (data, httpResponse) -> T in
                do {
                    let decoded = try self.jsonDecoder.decode(T.self, from: data)
                    Logger.shared.log("Successfully decoded response from \(url.absoluteString)", level: .info)
                    return decoded
                } catch {
                    let responseDetails = NetworkError.ResponseDetails(responseBody: data, statusCode: httpResponse.statusCode)
                    throw NetworkError(request: requestDetails, response: responseDetails, underlyingError: error)
                }
            }
            .mapError { error in
                Logger.shared.log("Error in network request to \(url.absoluteString): \(error.localizedDescription)", level: .error)
                return error
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
