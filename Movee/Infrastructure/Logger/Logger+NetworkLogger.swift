//
//  Logger+NetworkLogger.swift
//  Movee
//
//  Created by user on 11/23/25.
//

extension Logger: NetworkLogger {
    public func logNetworkRequest(_ message: String) {
        log(message, level: .info)
    }
    
    public func logNetworkResponse(_ message: String) {
        log(message, level: .info)
    }
    
    public func logNetworkError(_ message: String) {
        log(message, level: .error)
    }
}
