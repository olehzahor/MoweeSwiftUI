//
//  MediaRowView.swift
//  Movee
//
//  Created by user on 4/8/25.
//

import SwiftUI

struct MediaRowView: View {
    let data: DataModel
    
    @State var isExpanded: Bool = false
    @State private var posterSize: CGSize = .zero
    
    private var maxHeight: CGFloat? {
        isExpanded ? nil : 150// posterSize.height
    }
    
    private var subtitleLineLimit: Int? {
        isExpanded ? nil : 1
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            MediaPosterView(.init(posterURL: data.posterURL, posterPlaceholder: data.placeholder))
                .saveSize(in: $posterSize)
            VStack(alignment: .leading, spacing: 4) {
                Text(data.title)
                    .multilineTextAlignment(.leading)
                    .textStyle(.mediumTitle)
                if let subtitle = data.subtitle {
                    Text(subtitle)
                        .multilineTextAlignment(.leading)
                        .textStyle(.mediumSubtitle)
                        .fontWeight(.semibold)
                        .lineLimit(subtitleLineLimit)
                }
                FoldableTextView(text: data.overview, lineLimit: nil) {
                    isExpanded = true
                }
                .textStyle(.mediumText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }.frame(maxHeight: maxHeight)
    }
    
    init(data: DataModel) {
        self.data = data
    }
}
