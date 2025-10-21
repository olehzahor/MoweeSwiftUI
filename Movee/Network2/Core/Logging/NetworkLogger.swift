//
//  NetworkLogger.swift
//  Movee
//
//  Created by user on 19.10.25.
//

import Foundation

/// Protocol for logging network operations
/// This protocol is defined by the Network2 module to specify its logging needs
/// without depending on any concrete logging implementation
public protocol NetworkLogger {
    /// Logs an outgoing network request
    /// - Parameter request: The URLRequest about to be sent
    func logRequest(_ request: URLRequest)

    /// Logs a successful network response
    /// - Parameters:
    ///   - response: The HTTP response received
    ///   - data: The response body data
    ///   - duration: Time taken for the request in seconds
    func logResponse(_ response: HTTPURLResponse, data: Data, duration: TimeInterval)

    /// Logs a network error
    /// - Parameters:
    ///   - error: The error that occurred
    ///   - request: The request that failed
    func logError(_ error: Error, for request: URLRequest)
}
