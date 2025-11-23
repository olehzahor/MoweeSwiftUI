//
//  NetworkLogger.swift
//  Movee
//
//  Created by user on 19.10.25.
//

import Foundation

public protocol NetworkLogger {
    func logNetworkRequest(_ message: String)
    func logNetworkResponse(_ message: String)
    func logNetworkError(_ message: String)
}
