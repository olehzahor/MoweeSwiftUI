//
//  DataDecoder.swift
//  Movee
//
//  Created by Oleh on 16.10.2025.
//

import Foundation

protocol DataDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}
