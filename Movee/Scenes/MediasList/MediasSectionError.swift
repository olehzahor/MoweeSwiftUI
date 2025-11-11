//
//  MediasSectionError.swift
//  Movee
//
//  Created by user on 11/11/25.
//

import Foundation

enum MediasSectionError: String, LocalizedError {
    case noDataProvider = "No data provider has been provided for this section"
    
    var errorDescription: String? { rawValue }
}
