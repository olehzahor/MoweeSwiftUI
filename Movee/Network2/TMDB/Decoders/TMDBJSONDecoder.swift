//
//  TMDBJSONDecoder.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation

struct TMDBJSONDecoder: DataDecoder {
    private let decoder: JSONDecoder

    init() {
        let jsonDecoder = JSONDecoder()

        // ISO8601 formatter supporting fractional seconds
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        // Custom strategy: try fractional-second parser, else throw
        jsonDecoder.dateDecodingStrategy = .custom { decoder in
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

        self.decoder = jsonDecoder
    }

    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        try decoder.decode(type, from: data)
    }
}
