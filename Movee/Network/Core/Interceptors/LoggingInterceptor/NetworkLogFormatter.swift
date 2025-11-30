//
//  NetworkLogFormatter.swift
//  Movee
//
//  Created by user on 11/23/25.
//

import Foundation

protocol NetworkLogFormatterProtocol {
    func formatRequest(_ request: URLRequest) -> String
    func formatResponse(_ response: HTTPURLResponse, data: Data, duration: TimeInterval) -> String
    func formatError(_ error: Error, for request: URLRequest) -> String
}

struct NetworkLogFormatter: NetworkLogFormatterProtocol {
    let mode: LogMode

    func formatRequest(_ request: URLRequest) -> String {
        let method = request.httpMethod ?? "REQUEST"
        let url = request.url?.absoluteString ?? "unknown"
        var output = "\n⏩ \(method) \(url)"

        switch mode {
        case .compact:
            return output

        case .full, .truncated:
            if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
                let headersString = headers.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
                output += "\n  Headers: \(headersString)"
            }

            if let body = request.httpBody,
               let bodyString = String(data: body, encoding: .utf8) {
                let formattedBody = formatBody(bodyString)
                output += "\n  Body: \(formattedBody)"
            }

            return output
        }
    }

    func formatResponse(_ response: HTTPURLResponse, data: Data, duration: TimeInterval) -> String {
        let statusCode = response.statusCode
        let url = response.url?.absoluteString ?? "unknown"
        let emoji = statusCode < 400 ? "✅" : "❌"

        let durationMs = Int(duration * 1000)
        let durationString = "\(durationMs)ms"

        let sizeString = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .binary)

        var output = "\n\(emoji) \(statusCode) \(url) (\(durationString), \(sizeString))"

        switch mode {
        case .compact:
            return output

        case .full, .truncated:
            if let bodyString = String(data: data, encoding: .utf8) {
               let formattedBody = formatBody(bodyString)
                output += "\n  Response body: \(formattedBody)"
            }
            return output
        }
    }

    func formatError(_ error: Error, for request: URLRequest) -> String {
        let method = request.httpMethod ?? "REQUEST"
        let url = request.url?.absoluteString ?? "unknown"

        return "\n❌ \(method) \(url) failed: \(error)"
    }

    private func formatBody(_ body: String) -> String {
        if case .truncated(let maxLength) = mode, body.count > maxLength {
            let truncated = String(body.prefix(maxLength))
            return "\(truncated)... (truncated, total: \(body.count) chars)"
        }
        return body
    }
}

extension NetworkLogFormatter {
    enum LogMode {
        case compact
        case full
        case truncated(maxLength: Int)
    }
}
