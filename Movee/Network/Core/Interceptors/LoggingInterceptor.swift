//
//  LoggingInterceptor.swift
//  Movee
//
//  Created by user on 19.10.25.
//

import Foundation

private actor TimingTracker {
    private var requestStartTimes: [String: Date] = [:]

    func recordStart(for key: String) {
        requestStartTimes[key] = Date()
    }

    func calculateDuration(for key: String) -> TimeInterval {
        guard let startTime = requestStartTimes[key] else {
            return 0
        }
        requestStartTimes.removeValue(forKey: key)
        return Date().timeIntervalSince(startTime)
    }

    func cleanup(for key: String) {
        requestStartTimes.removeValue(forKey: key)
    }
}

final class LoggingInterceptor: NetworkInterceptor {
    private let logger: NetworkLogger
    private let timingTracker = TimingTracker()

    private func requestKey(for request: URLRequest) -> String {
        return request.url?.absoluteString ?? UUID().uuidString
    }

    private func requestKey(for response: HTTPURLResponse) -> String {
        return response.url?.absoluteString ?? ""
    }

    func intercept(request: URLRequest) async throws -> URLRequest {
        let requestKey = requestKey(for: request)

        await timingTracker.recordStart(for: requestKey)
        logger.logRequest(request)

        return request
    }

    func intercept(response: HTTPURLResponse, data: Data) async throws -> Data {
        let requestKey = requestKey(for: response)
        let duration = await timingTracker.calculateDuration(for: requestKey)

        logger.logResponse(response, data: data, duration: duration)

        return data
    }

    func intercept(error: Error, request: URLRequest) async -> Error {
        let requestKey = requestKey(for: request)

        await timingTracker.cleanup(for: requestKey)
        logger.logError(error, for: request)

        return error
    }
    
    init(logger: NetworkLogger) {
        self.logger = logger
    }
}

