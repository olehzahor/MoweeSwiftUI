//
//  MediaType.swift
//  Movee
//
//  Created by user on 11/10/25.
//

extension MediaType {
    init?(_ mediaType: MediasList.MediaType?) {
        switch mediaType {
        case .none, .movie:
            self = .movie
        case .tv:
            self = .tvShow
        default:
            return nil
        }
    }
}
