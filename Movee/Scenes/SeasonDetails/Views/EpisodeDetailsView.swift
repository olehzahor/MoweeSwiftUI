//
//  EpisodeDetailsView.swift
//  Movee
//
//  Created by user on 11/9/25.
//

import SwiftUI

struct EpisodeDetailsView: View {
    var episode: Episode
    
    @State var isExpanded: Bool = false
    @State private var posterSize: CGSize = .zero
    
    private var maxHeight: CGFloat? {
        isExpanded ? nil : (posterSize.height == .zero ? nil : posterSize.height)
    }
    
    private var titleLineLimit: Int? {
        isExpanded ? nil : 1
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(episode.episodeNumber). \(episode.name)")
                    .multilineTextAlignment(.leading)
                    .textStyle(.mediumTitle)
                if let detailsString = episode.detailsString {
                    Text(detailsString)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.secondary)
                        .textStyle(.smallText)
                        .fontWeight(.semibold)
                }
                FoldableTextView(text: episode.overview, lineLimit: nil) {
                    isExpanded = true
                }
                .hidden(episode.overview.isEmpty)
                .textStyle(.smallText)
                .lineSpacing(-3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if let stillURL = episode.stillURL {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImageView(url: stillURL, width: 110, height: 93, cornerRadius: 8, placeholder: .imageMoviePlaceholder)
                        .saveSize(in: $posterSize)
                    if let rating = episode.voteAverage, rating > 0 {
                        MediaRatingView(rating: rating)
                            .padding(.bottom, 4)
                            .padding(.trailing, 4)
                    }
                }
            }
        }.frame(maxHeight: maxHeight)
    }
}
