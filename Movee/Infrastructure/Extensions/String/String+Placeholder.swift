//
//  PlaceholderLength.swift
//  Movee
//
//  Created by user on 4/27/25.
//


import SwiftUI
import Combine

extension String {
    enum PlaceholderLength {
        case short, medium, long
        case custom(Int)
        
        var length: Int {
            switch self {
            case .short:
                10
            case .medium:
                25
            case .long:
                50
            case .custom(let length):
                length
            }
        }
    }
    
    static func placeholder(_ length: PlaceholderLength) -> String {
        let chars = Array(repeating: Character("#"), count: length.length)
        return String(chars)
    }
}
