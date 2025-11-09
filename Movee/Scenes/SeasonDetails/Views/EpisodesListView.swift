//
//  EpisodesListView.swift
//  Movee
//
//  Created by user on 11/9/25.
//

import SwiftUI

struct EpisodesListView: View {
    @Environment(\.placeholder) private var placeholder: Bool
    
    private let _episodes: [Episode]
    
    private var episodes: [Episode] {
        placeholder ? Array(repeating: Episode.placeholder, count: 10) : _episodes
    }

    var body: some View {
        ForEach(Array(episodes.enumerated()), id: \.offset) { _, episode in
            EpisodeDetailsView(episode: episode)
                .loadable()
        }
    }
    
    init(episodes: [Episode]? = nil) {
        self._episodes = episodes ?? []
    }
}
