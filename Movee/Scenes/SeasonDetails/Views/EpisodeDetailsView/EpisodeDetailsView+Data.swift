//
//  EpisodeDetailsView+Data.swift
//  Movee
//
//  Created by user on 11/26/25.
//

import Foundation

extension EpisodeDetailsView {
    struct Data {
        let episodeNumber: Int
        let name: String
        let detailsString: String?
        let overview: String
        let stillURL: URL?
        let voteAverage: Double?
    }
}

extension EpisodeDetailsView.Data {
    init(_ episode: Episode) {
        self.episodeNumber = episode.episodeNumber
        self.name = episode.name
        self.detailsString = episode.detailsString
        self.overview = episode.overview
        self.stillURL = episode.stillURL
        self.voteAverage = episode.voteAverage
    }
}
