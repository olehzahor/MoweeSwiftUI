//
//  EpisodeDetailsView.swift
//  Movee
//
//  Created by user on 11/9/25.
//

import SwiftUI

struct EpisodeDetailsView: View {
    @Environment(\.placeholder) private var placeholder: Bool

    let data: Data

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
                Text("\(data.episodeNumber). \(data.name)")
                    .multilineTextAlignment(.leading)
                    .textStyle(.mediumTitle)
                if let detailsString = data.detailsString {
                    Text(detailsString)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.secondary)
                        .textStyle(.smallText)
                        .fontWeight(.semibold)
                }
                FoldableTextView(text: data.overview, lineLimit: nil) {
                    isExpanded = true
                }
                .hidden(data.overview.isEmpty)
                .textStyle(.smallText)
                .lineSpacing(-3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            MediaPosterView(
                data: .init(posterURL: data.stillURL,
                            rating: data.voteAverage,
                            placeholder: .imageMoviePlaceholder),
                config: .init(width: 100,
                              height: 93,
                              showTitles: false)
            )
            .saveSize(in: $posterSize)
            .hidden(data.stillURL == nil && !placeholder)
        }.frame(maxHeight: maxHeight)
    }
}
