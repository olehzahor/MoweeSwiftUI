//
//  NetworkInterceptor.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation

protocol NetworkInterceptor {
    func intercept(request: URLRequest) async throws -> URLRequest
    func intercept(response: HTTPURLResponse, data: Data) async throws -> Data
    func intercept(error: Error, request: URLRequest) async throws
}

extension NetworkInterceptor {
    func intercept(response: HTTPURLResponse, data: Data) async throws -> Data {
        return data
    }

    func intercept(error: Error, request: URLRequest) async throws {
        throw error
    }
}
