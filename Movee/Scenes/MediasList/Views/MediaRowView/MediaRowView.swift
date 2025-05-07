//
//  MediaRowView.swift
//  Movee
//
//  Created by user on 4/8/25.
//

import SwiftUI

struct MediaRowView: View {
    let data: MediaUIModel
    
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
            // TODO: add styling (hide titles when needed)
            MediaPosterView(.init(posterURL: data.posterURL, placeholder: data.placeholder, rating: data.rating))
                .saveSize(in: $posterSize)
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
        }.frame(maxHeight: maxHeight)
    }
    
    init(data: MediaUIModel) {
        self.data = data
    }
}
