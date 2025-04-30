//
//  TMDBImageURLProvider.swift
//  Movee
//
//  Created by user on 4/30/25.
//

import Foundation

final class TMDBImageURLProvider {
    static let shared = TMDBImageURLProvider()
    private init() {}

    private let baseURLString = "https://image.tmdb.org/t/p/"

    enum Size: String {
        case w92 = "w92"
        case w154 = "w154"
        case w185 = "w185"
        case w342 = "w342"
        case w500 = "w500"
        case w780 = "w780"
        case w1280 = "w1280"
        case original = "original"
    }

    func url(path: String?, size: Size) -> URL? {
        guard let path = path else { return nil }
        return URL(string: baseURLString + size.rawValue + path)
    }
}
