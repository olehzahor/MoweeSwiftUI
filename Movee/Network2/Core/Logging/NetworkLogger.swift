//
//  NetworkLogger.swift
//  Movee
//
//  Created by user on 19.10.25.
//

import Foundation

public protocol NetworkLogger {
    func logRequest(_ request: URLRequest)
    func logResponse(_ response: HTTPURLResponse, data: Data, duration: TimeInterval)
    func logError(_ error: Error, for request: URLRequest)
}
