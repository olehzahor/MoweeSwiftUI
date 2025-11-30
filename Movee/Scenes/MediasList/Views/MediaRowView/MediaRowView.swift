//
//  MediaRowView.swift
//  Movee
//
//  Created by Oleh on 06.11.2025.
//

import SwiftUI

struct MediaRowView: View {
    @Environment(\.placeholder) var placeholder: Bool

    private let _data: Data

    var data: Data {
        placeholder ? .placeholder : _data
    }

    @State var isExpanded: Bool = false
    private let posterConfig = MediaPosterView.Config.row

    private var posterHeight: CGFloat {
        posterConfig.height
    }

    private var subtitleLineLimit: Int? {
        isExpanded ? nil : 1
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            MediaPosterView(data: data.posterData, config: posterConfig)
            VStack(alignment: .leading, spacing: 4) {
                if let title = data.title {
                    Text(title)
                        .multilineTextAlignment(.leading)
                        .textStyle(.mediumTitle)
                }
                if let details = data.details {
                    Text(details)
                        .multilineTextAlignment(.leading)
                        .textStyle(.mediumSubtitle)
                        .fontWeight(.semibold)
                        .lineLimit(subtitleLineLimit)
                }
                if let overview = data.overview {
                    FoldableTextView(text: overview, lineLimit: nil) {
                        isExpanded = true
                    }
                    .textStyle(.mediumText)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxHeight: isExpanded ? nil : posterHeight)
        .loadable()
        .fallible()
    }

    init(data: Data = .placeholder) {
        self._data = data
    }
}

extension MediaRowView: Equatable {
    static func == (lhs: MediaRowView, rhs: MediaRowView) -> Bool {
        lhs._data.id == rhs._data.id
    }
}
