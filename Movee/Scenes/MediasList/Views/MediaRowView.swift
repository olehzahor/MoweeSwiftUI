//
//  MediaRowView.swift
//  Movee
//
//  Created by user on 4/8/25.
//

import SwiftUI

struct MediaRowView: View {
    let title: String
    let posterURL: URL?
    let overview: String
    let year: Int
    let genre: String
    
    @State var isExpanded: Bool = false
    @State private var posterSize: CGSize = .zero
    
    private var maxHeight: CGFloat? {
        isExpanded ? nil : posterSize.height
    }
    
    private var subtitleLineLimit: Int? {
        isExpanded ? nil : 1
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            MediaPosterView(.init(posterURL: posterURL)).saveSize(in: $posterSize)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .multilineTextAlignment(.leading)
                    .textStyle(.mediumTitle)
                Text( "\(String(year)) · \(genre)")
                    .multilineTextAlignment(.leading)
                    .textStyle(.mediumSubtitle)
                    .fontWeight(.semibold)
                    .lineLimit(subtitleLineLimit)
                FoldableTextView(text: overview, lineLimit: nil) {
                    isExpanded = true
                }
                .textStyle(.mediumText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }.frame(maxHeight: maxHeight)
    }
    
    // Initializer using a Media object
    init(media: Media) {
        self.title = media.title
        self.posterURL = media.posterURL
        self.overview = media.overview
        self.year = media.releaseYear
        self.genre = media.genresString
    }
    
    init(title: String, posterURL: URL? = nil, overview: String, year: Int, genre: String) {
        self.title = title
        self.posterURL = posterURL
        self.overview = overview
        self.year = year
        self.genre = genre
    }
}
