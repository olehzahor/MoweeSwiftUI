//
//  MediaDetailedInfoView.swift
//  Movee
//
//  Created by user on 4/10/25.
//

import SwiftUI

struct MediaDetailedInfoView: View {
    @Environment(\.placeholder) private var placeholder: Bool
    
    private let _data: Data
    
    private var data: Data {
        placeholder ? .init(media: .placeholder) : _data
    }

    private var subtitle: String {
        let strings = [data.releaseDate, data.duration].compactMap { $0 }
        var string = strings.joined(separator: " · ")
        if !string.isEmpty {
            string += "\n"
        }
        if !data.genres.isEmpty {
            string += "\(data.genres)"
        }
        return string
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            MediaPosterView(.init(posterURL: data.posterURL, rating: data.mediaRating))
            Spacer()
            VStack(spacing: 8) {
                Text(data.title)
                    .textStyle(.mediaLargeTitle)
                    .lineLimit(3)
                Text(subtitle)
                    .textStyle(.smallText)
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .loadable()
        .failable()
    }
    
    init(data: Data) {
        self._data = data
    }
}

extension MediaDetailedInfoView {
    init(media: Media) {
        self._data = .init(media: media)
    }
}
