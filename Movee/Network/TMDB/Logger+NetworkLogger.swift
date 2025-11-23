//
//  Logger+NetworkLogger.swift
//  Movee
//
//  Created by Oleh on 20.10.2025.
//

import Foundation

extension Logger: NetworkLogger {
    public func logRequest(_ request: URLRequest) {
        let method = request.httpMethod ?? "REQUEST"
        let url = request.url?.absoluteString ?? "unknown"

        log("\n⏩ \(method) \(url)", level: .debug)

        // Log headers if present
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            let headersString = headers.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            log("  Headers: \(headersString)", level: .debug)
        }

        // Log body if present (for POST/PUT/PATCH)
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            log("  Body: \(bodyString)", level: .debug)
        }
    }

    public func logResponse(_ response: HTTPURLResponse, data: Data, duration: TimeInterval) {
        let statusCode = response.statusCode
        let url = response.url?.absoluteString ?? "unknown"
        let emoji = statusCode < 400 ? "✅" : "❌"

        // Format duration
        let durationString = String(format: "%.2f", duration)

        // Format data size
        let sizeString = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .binary)

        let level: LogLevel = statusCode < 400 ? .info : .error
        log("\n\(emoji) \(statusCode) \(url) (\(durationString)s, \(sizeString))", level: level)

        // Log response body for debugging (only for small responses in debug builds)
        #if DEBUG
        if data.count < 5000, // Only log small responses
           let bodyString = String(data: data, encoding: .utf8) {
            log("  Response body: \(bodyString)", level: .debug)
        }
        #endif
    }

    public func logError(_ error: any Error, for request: URLRequest) {
        let method = request.httpMethod ?? "REQUEST"
        let url = request.url?.absoluteString ?? "unknown"

        log("\n❌ \(method) \(url) failed: \(error)", level: .error)
    }
}
