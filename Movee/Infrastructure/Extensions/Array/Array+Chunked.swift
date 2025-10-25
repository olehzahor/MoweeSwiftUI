//
//  Array+Chunked.swift
//  Movee
//
//  Created by Oleh on 25.10.2025.
//

import Foundation

extension Array {
    /// Splits array into chunks of specified size
    /// - Parameter size: Maximum size of each chunk
    /// - Returns: Array of chunks
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
